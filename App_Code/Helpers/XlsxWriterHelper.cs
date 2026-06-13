using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.IO.Compression;
using System.Text;

namespace Helpers
{
    public class XlsxWriterHelper
    {
        private Dictionary<string, byte[]> _entries = new Dictionary<string, byte[]>();
        private int _imageCount = 0;
        private int _drawingCount = 0;

        public void AddEntry(string path, string xml) { _entries[path] = Encoding.UTF8.GetBytes(xml); }
        public void AddEntry(string path, byte[] data) { _entries[path] = data; }

        public byte[] Build()
        {
            using (var ms = new MemoryStream())
            {
                using (var zip = new ZipArchive(ms, ZipArchiveMode.Create, true))
                {
                    foreach (var entry in _entries)
                    {
                        var ze = zip.CreateEntry(entry.Key, CompressionLevel.Fastest);
                        using (var es = ze.Open()) es.Write(entry.Value, 0, entry.Value.Length);
                    }
                }
                return ms.ToArray();
            }
        }

        public void WriteToResponse(string fileName)
        {
            var bytes = Build();
            var resp = System.Web.HttpContext.Current.Response;
            resp.Clear();
            resp.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            resp.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
            resp.BinaryWrite(bytes);
            resp.End();
        }

        public static string EscapeXml(string text)
        {
            if (string.IsNullOrEmpty(text)) return "";
            return text.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;")
                       .Replace("\"", "&quot;").Replace("'", "&apos;");
        }

        public string AddChartImage(string title, string[] labels, decimal[] values)
        {
            _imageCount++;
            _drawingCount++;
            var imgId = _imageCount;
            var drawId = _drawingCount;

            if (labels == null || labels.Length == 0) labels = new[] { "无数据" };
            if (values == null || values.Length == 0) values = new[] { 0m };

            int width = 760, height = 380;
            using (var bmp = new Bitmap(width, height))
            using (var g = Graphics.FromImage(bmp))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.Clear(Color.White);

                var titleFont = new Font("Microsoft YaHei", 14, FontStyle.Bold);
                var labelFont = new Font("Microsoft YaHei", 9);
                var valFont = new Font("Microsoft YaHei", 9);

                // Title
                g.DrawString(title, titleFont, Brushes.DodgerBlue, 20, 10);

                // Chart area
                int marginLeft = 80, marginRight = 40, marginTop = 50, marginBottom = 60;
                int chartW = width - marginLeft - marginRight;
                int chartH = height - marginTop - marginBottom;

                var maxVal = 1m;
                foreach (var v in values) if (v > maxVal) maxVal = v;
                if (maxVal <= 0) maxVal = 1m;
                maxVal = Math.Ceiling(maxVal * 1.15m);

                // Grid lines
                using (var pen = new Pen(Color.FromArgb(230, 230, 230), 1))
                {
                    for (int i = 0; i <= 4; i++)
                    {
                        int y = marginTop + chartH * i / 4;
                        g.DrawLine(pen, marginLeft, y, marginLeft + chartW, y);
                        g.DrawString((maxVal * (4 - i) / 4).ToString("F0"), labelFont, Brushes.Gray,
                            marginLeft - 50, y - 8);
                    }
                }

                // Bars
                int barCount = labels.Length;
                float barWidth = (float)chartW / barCount * 0.6f;
                float barGap = (float)chartW / barCount * 0.4f;

                for (int i = 0; i < barCount; i++)
                {
                    float barH = Math.Max(1, (float)((double)values[i] / (double)maxVal * chartH));
                    float x = marginLeft + (float)chartW / barCount * i + barGap / 2;
                    float y = marginTop + chartH - barH;

                    using (var brush = new LinearGradientBrush(new PointF(0, y), new PointF(0, y + barH),
                        Color.FromArgb(24, 144, 255), Color.FromArgb(54, 207, 201)))
                    {
                        g.FillRectangle(brush, x, y, barWidth, barH);
                    }
                    using (var pen = new Pen(Color.FromArgb(24, 144, 255), 1))
                        g.DrawRectangle(pen, x, y, barWidth, barH);

                    // Value label
                    string valText = values[i].ToString("F0");
                    var valSize = g.MeasureString(valText, valFont);
                    g.DrawString(valText, valFont, Brushes.Black, x + barWidth / 2 - valSize.Width / 2, y - 18);

                    // Category label
                    var catSize = g.MeasureString(labels[i], labelFont);
                    g.DrawString(labels[i], labelFont, Brushes.Black,
                        x + barWidth / 2 - catSize.Width / 2, marginTop + chartH + 5);
                }

                // Axes
                using (var pen = new Pen(Color.Black, 2))
                {
                    g.DrawLine(pen, marginLeft, marginTop, marginLeft, marginTop + chartH);
                    g.DrawLine(pen, marginLeft, marginTop + chartH, marginLeft + chartW, marginTop + chartH);
                }

                titleFont.Dispose();
                labelFont.Dispose();
                valFont.Dispose();

                using (var ms = new MemoryStream())
                {
                    bmp.Save(ms, ImageFormat.Png);
                    AddEntry("xl/media/image" + imgId + ".png", ms.ToArray());
                }
            }

            // Drawing XML
            var imgEMU = 9525 * width;
            var imgEMU2 = 9525 * height;
            // Place image below the data on the sheet

            var drawXml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
                "<xdr:wsDr xmlns:xdr=\"http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing\" " +
                "xmlns:a=\"http://schemas.openxmlformats.org/drawingml/2006/main\" " +
                "xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\">" +
                "<xdr:twoCellAnchor editAs=\"oneCell\">" +
                "<xdr:from><xdr:col>0</xdr:col><xdr:colOff>0</xdr:colOff><xdr:row>0</xdr:row><xdr:rowOff>0</xdr:rowOff></xdr:from>" +
                "<xdr:to><xdr:col>9</xdr:col><xdr:colOff>0</xdr:colOff><xdr:row>24</xdr:row><xdr:rowOff>0</xdr:rowOff></xdr:to>" +
                "<xdr:pic>" +
                "<xdr:nvPicPr><xdr:cNvPr id=\"" + imgId + "\" name=\"Chart\" descr=\"" + EscapeXml(title) + "\"/><xdr:cNvPicPr/></xdr:nvPicPr>" +
                "<xdr:blipFill><a:blip r:embed=\"rId1\"/><a:stretch><a:fillRect/></a:stretch></xdr:blipFill>" +
                "<xdr:spPr><a:xfrm><a:off x=\"0\" y=\"0\"/><a:ext cx=\"" + imgEMU + "\" cy=\"" + imgEMU2 + "\"/></a:xfrm>" +
                "<a:prstGeom prst=\"rect\"><a:avLst/></a:prstGeom></xdr:spPr>" +
                "</xdr:pic>" +
                "<xdr:clientData/>" +
                "</xdr:twoCellAnchor></xdr:wsDr>";

            var drawPath = "xl/drawings/drawing" + drawId + ".xml";
            AddEntry(drawPath, drawXml);

            var drawRels = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
                "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">" +
                "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/image\" Target=\"../media/image" + imgId + ".png\"/>" +
                "</Relationships>";
            AddEntry("xl/drawings/_rels/drawing" + drawId + ".xml.rels", drawRels);

            return "drawing" + drawId;
        }

        public static string BuildStylesXml()
        {
            return @"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>
<styleSheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"">
<fonts count=""3"">
  <font><sz val=""11""/><name val=""Microsoft YaHei""/></font>
  <font><b/><sz val=""12""/><name val=""Microsoft YaHei""/><color rgb=""FFFFFFFF""/></font>
  <font><b/><sz val=""11""/><name val=""Microsoft YaHei""/></font>
</fonts>
<fills count=""4"">
  <fill><patternFill patternType=""none""/></fill>
  <fill><patternFill patternType=""gray125""/></fill>
  <fill><patternFill patternType=""solid""><fgColor rgb=""FF1890FF""/></patternFill></fill>
  <fill><patternFill patternType=""solid""><fgColor rgb=""FFF5F5F5""/></patternFill></fill>
</fills>
<borders count=""2"">
  <border><left/><right/><top/><bottom/><diagonal/></border>
  <border><left style=""thin""><color rgb=""FFD9D9D9""/></left><right style=""thin""><color rgb=""FFD9D9D9""/></right>
    <top style=""thin""><color rgb=""FFD9D9D9""/></top><bottom style=""thin""><color rgb=""FFD9D9D9""/></bottom><diagonal/></border>
</borders>
<cellStyleXfs count=""1""><xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""0""/></cellStyleXfs>
<cellXfs count=""4"">
  <xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""0"" xfId=""0""/>
  <xf numFmtId=""0"" fontId=""1"" fillId=""2"" borderId=""1"" xfId=""0"" alignment=""{horizontal=""center""}""/>
  <xf numFmtId=""0"" fontId=""2"" fillId=""3"" borderId=""1"" xfId=""0""/>
  <xf numFmtId=""2"" fontId=""0"" fillId=""0"" borderId=""1"" xfId=""0""/>
</cellXfs>
<cellStyles count=""1""><cellStyle name=""Normal"" xfId=""0"" builtinId=""0""/></cellStyles>
</styleSheet>";
        }

        public static string BuildContentTypesXml(List<string> sheetNames, int imageCount)
        {
            var xml = @"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>
<Types xmlns=""http://schemas.openxmlformats.org/package/2006/content-types"">
  <Default Extension=""xml"" ContentType=""application/xml""/>
  <Default Extension=""rels"" ContentType=""application/vnd.openxmlformats-package.relationships+xml""/>
  <Default Extension=""png"" ContentType=""image/png""/>
  <Override PartName=""/xl/workbook.xml"" ContentType=""application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml""/>
  <Override PartName=""/xl/styles.xml"" ContentType=""application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml""/>";
            for (int i = 0; i < sheetNames.Count; i++)
                xml += "<Override PartName=\"/xl/worksheets/sheet" + (i + 1) + ".xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>";
            for (int i = 1; i <= imageCount; i++)
                xml += "<Override PartName=\"/xl/drawings/drawing" + i + ".xml\" ContentType=\"application/vnd.openxmlformats-officedocument.drawing+xml\"/>";
            xml += @"</Types>";
            return xml;
        }

        public static string BuildRelsXml()
        {
            return @"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>
<Relationships xmlns=""http://schemas.openxmlformats.org/package/2006/relationships"">
  <Relationship Id=""rId1"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"" Target=""xl/workbook.xml""/>
</Relationships>";
        }

        public static string BuildWorkbookXml(List<string> sheetNames)
        {
            var xml = @"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>
<workbook xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"" xmlns:r=""http://schemas.openxmlformats.org/officeDocument/2006/relationships""><sheets>";
            for (int i = 0; i < sheetNames.Count; i++)
                xml += "<sheet name=\"" + EscapeXml(sheetNames[i]) + "\" sheetId=\"" + (i + 1) + "\" r:id=\"rId" + (i + 1) + "\"/>";
            xml += @"</sheets></workbook>";
            return xml;
        }

        public static string BuildWorkbookRelsXml(List<string> sheetNames, List<string> drawingRefs)
        {
            var xml = @"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>
<Relationships xmlns=""http://schemas.openxmlformats.org/package/2006/relationships"">";
            for (int i = 0; i < sheetNames.Count; i++)
                xml += "<Relationship Id=\"rId" + (i + 1) + "\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet" + (i + 1) + ".xml\"/>";
            xml += @"<Relationship Id=""rId99"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"" Target=""styles.xml""/>";
            if (drawingRefs != null)
            {
                for (int i = 0; i < drawingRefs.Count; i++)
                    xml += "<Relationship Id=\"rIdDraw" + (i + 1) + "\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing\" Target=\"../drawings/" + drawingRefs[i] + ".xml\"/>";
            }
            xml += @"</Relationships>";
            return xml;
        }

        public static string BuildSheetDataXml(List<string[]> rows, int[] colWidths, string drawingRelTarget, string title = null)
        {
            var sb = new StringBuilder();
            sb.Append(@"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>");
            sb.Append(@"<worksheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"" xmlns:r=""http://schemas.openxmlformats.org/officeDocument/2006/relationships"">");
            sb.Append("<sheetViews><sheetView tabSelected=\"1\" workbookViewId=\"0\">");
            if (!string.IsNullOrEmpty(title))
                sb.Append("<pane yOffset=\"2\" xSplit=\"0\" ySplit=\"2\" state=\"frozen\" activePane=\"bottomLeft\"/>");
            else
                sb.Append("<pane yOffset=\"1\" xSplit=\"0\" ySplit=\"1\" state=\"frozen\" activePane=\"bottomLeft\"/>");
            sb.Append("</sheetView></sheetViews>");

            sb.Append("<cols>");
            for (int i = 0; i < colWidths.Length; i++)
                sb.AppendFormat("<col min=\"{0}\" max=\"{0}\" width=\"{1}\" customWidth=\"1\"/>", i + 1, colWidths[i]);
            sb.Append("</cols>");

            // Merged cells for title row
            if (!string.IsNullOrEmpty(title))
            {
                var lastCol = (char)('A' + colWidths.Length - 1);
                sb.AppendFormat("<mergeCells count=\"1\"><mergeCell ref=\"A1:{0}1\"/></mergeCells>", lastCol);
            }

            sb.Append("<sheetData>");

            // Title row
            int dataStartRow = 1;
            if (!string.IsNullOrEmpty(title))
            {
                var lastCol = (char)('A' + colWidths.Length - 1);
                sb.AppendFormat("<row r=\"1\" ht=\"28\"><c r=\"A1\" s=\"1\" t=\"inlineStr\"><is><t>{0}</t></is></c>", EscapeXml(title));
                for (int c = 1; c < colWidths.Length; c++)
                    sb.AppendFormat("<c r=\"{0}1\" s=\"1\"/>", (char)('A' + c));
                sb.Append("</row>");
                dataStartRow = 2;
            }

            for (int r = 0; r < rows.Count; r++)
            {
                var row = rows[r];
                var rowNum = r + dataStartRow;
                sb.AppendFormat("<row r=\"{0}\">", rowNum);
                for (int c = 0; c < row.Length; c++)
                {
                    var val = EscapeXml(row[c] ?? "");
                    var col = (char)('A' + c);
                    if (r == 0)
                        sb.AppendFormat("<c r=\"{0}{1}\" t=\"inlineStr\" s=\"1\"><is><t>{2}</t></is></c>", col, rowNum, val);
                    else if (decimal.TryParse(row[c], out _))
                        sb.AppendFormat("<c r=\"{0}{1}\"><v>{2}</v></c>", col, rowNum, val);
                    else
                        sb.AppendFormat("<c r=\"{0}{1}\" t=\"inlineStr\"><is><t>{2}</t></is></c>", col, rowNum, val);
                }
                sb.Append("</row>");
            }
            sb.Append("</sheetData>");

            if (rows.Count > 0)
            {
                var lastCol = (char)('A' + colWidths.Length - 1);
                sb.AppendFormat("<autoFilter ref=\"A{0}:{1}{2}\"/>", dataStartRow, lastCol, dataStartRow + rows.Count - 1);
            }

            if (!string.IsNullOrEmpty(drawingRelTarget))
                sb.AppendFormat("<drawing r:id=\"rId1\"/>");

            sb.Append("</worksheet>");
            return sb.ToString();
        }

        public static string BuildSheetRelsXml(string drawingRelTarget)
        {
            if (string.IsNullOrEmpty(drawingRelTarget)) return null;
            return @"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>
<Relationships xmlns=""http://schemas.openxmlformats.org/package/2006/relationships"">
  <Relationship Id=""rId1"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing"" Target=""../drawings/" + drawingRelTarget + @".xml""/>
</Relationships>";
        }
    }
}
