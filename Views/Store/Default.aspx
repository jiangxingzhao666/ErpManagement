<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.StoreFront" MaintainScrollPositionOnPostback="true" %>
<%@ Import Namespace="Helpers" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>便民超市 &mdash; 品质生活，触手可及</title>
    <style>
        /* ============================================================
           DESIGN TOKENS — Jonas Schmedtmann Style
           ============================================================ */
        :root {
            /* Primary palette */
            --color-primary: #e94560;
            --color-primary-light: #f06b80;
            --color-primary-dark: #c23152;
            --color-primary-bg: #fff5f5;

            /* Accent */
            --color-accent: #ff9f43;
            --color-accent-light: #ffbe76;

            /* Neutrals */
            --color-grey-50: #fafafa;
            --color-grey-100: #f5f5f5;
            --color-grey-200: #eeeeee;
            --color-grey-300: #e0e0e0;
            --color-grey-400: #bdbdbd;
            --color-grey-500: #9e9e9e;
            --color-grey-600: #757575;
            --color-grey-700: #616161;
            --color-grey-800: #424242;
            --color-grey-900: #212121;

            /* Dark surface */
            --color-dark: #1a1a2e;
            --color-dark-2: #0f3460;
            --color-dark-3: #16213e;

            /* Semantic */
            --color-success: #2ecc71;
            --color-success-light: #d4efdf;
            --color-error: #e74c3c;
            --color-error-light: #fadbd8;
            --color-warning: #f39c12;
            --color-warning-light: #fdebd0;

            /* Typography */
            --font-primary: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
            --font-display: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
            --font-cjk: 'Microsoft YaHei', 'PingFang SC', 'Noto Sans SC', sans-serif;

            --text-xs: 1.2rem;
            --text-sm: 1.3rem;
            --text-base: 1.5rem;
            --text-md: 1.6rem;
            --text-lg: 1.8rem;
            --text-xl: 2.0rem;
            --text-2xl: 2.4rem;
            --text-3xl: 3.2rem;
            --text-4xl: 4.4rem;

            --fw-regular: 400;
            --fw-medium: 500;
            --fw-semibold: 600;
            --fw-bold: 700;
            --fw-extrabold: 800;

            --line-height-tight: 1.1;
            --line-height-normal: 1.5;
            --line-height-relaxed: 1.7;

            /* Spacing (8px grid) */
            --space-1: 0.4rem;
            --space-2: 0.8rem;
            --space-3: 1.2rem;
            --space-4: 1.6rem;
            --space-5: 2.4rem;
            --space-6: 3.2rem;
            --space-7: 4.8rem;
            --space-8: 6.4rem;
            --space-9: 9.6rem;
            --space-10: 12.8rem;

            /* Borders */
            --radius-xs: 4px;
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 16px;
            --radius-xl: 24px;
            --radius-full: 9999px;

            /* Shadows */
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06), 0 1px 2px rgba(0, 0, 0, 0.04);
            --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.06), 0 2px 4px rgba(0, 0, 0, 0.04);
            --shadow-lg: 0 8px 30px rgba(0, 0, 0, 0.08), 0 3px 8px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 60px rgba(0, 0, 0, 0.12), 0 5px 15px rgba(0, 0, 0, 0.06);
            --shadow-glow: 0 0 0 3px rgba(233, 69, 96, 0.15);

            /* Transitions */
            --transition-fast: 0.15s ease;
            --transition-base: 0.25s ease;
            --transition-slow: 0.35s cubic-bezier(0.4, 0, 0.2, 1);

            /* Layout */
            --max-width: 124rem;
            --header-height: 6.4rem;
        }

        /* ============================================================
           BASE RESET
           ============================================================ */
        *,
        *::before,
        *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            font-size: 62.5%;
            scroll-behavior: smooth;
            scroll-padding-top: calc(var(--header-height) + var(--space-5));
        }

        body {
            font-family: var(--font-primary), var(--font-cjk);
            font-size: var(--text-base);
            font-weight: var(--fw-regular);
            line-height: var(--line-height-normal);
            color: var(--color-grey-800);
            background-color: var(--color-grey-50);
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        img {
            max-width: 100%;
            display: block;
        }

        button {
            cursor: pointer;
            font-family: inherit;
        }

        input {
            font-family: inherit;
        }

        /* ============================================================
           UTILITY
           ============================================================ */
        .container {
            max-width: var(--max-width);
            margin: 0 auto;
            padding: 0 var(--space-5);
        }

        .section {
            padding: var(--space-9) 0;
        }

        .section--grey {
            background-color: var(--color-grey-100);
        }

        .section__header {
            text-align: center;
            margin-bottom: var(--space-7);
        }

        .section__title {
            font-family: var(--font-display), var(--font-cjk);
            font-size: var(--text-3xl);
            font-weight: var(--fw-extrabold);
            color: var(--color-grey-900);
            line-height: var(--line-height-tight);
            letter-spacing: -0.5px;
            margin-bottom: var(--space-3);
        }

        .section__subtitle {
            font-size: var(--text-md);
            color: var(--color-grey-500);
            max-width: 48rem;
            margin: 0 auto;
        }

        /* ============================================================
           TOP BAR
           ============================================================ */
        .top-bar {
            background-color: var(--color-dark);
            color: #fff;
            font-size: var(--text-sm);
            padding: var(--space-2) 0;
        }

        .top-bar__inner {
            max-width: var(--max-width);
            margin: 0 auto;
            padding: 0 var(--space-5);
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: var(--space-5);
        }

        .top-bar__link {
            color: var(--color-grey-400);
            transition: color var(--transition-fast);
            font-size: var(--text-xs);
        }

        .top-bar__link:hover,
        .top-bar__link:focus {
            color: #fff;
        }

        .top-bar__divider {
            color: var(--color-grey-700);
        }

        /* ============================================================
           HEADER / NAVBAR
           ============================================================ */
        .header {
            background-color: #fff;
            height: var(--header-height);
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: var(--shadow-sm);
            border-bottom: 1px solid var(--color-grey-200);
        }

        .header__inner {
            max-width: var(--max-width);
            margin: 0 auto;
            padding: 0 var(--space-5);
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }

        .logo__icon {
            font-size: var(--text-2xl);
            line-height: 1;
        }

        .logo__text {
            font-family: var(--font-display), var(--font-cjk);
            font-size: var(--text-xl);
            font-weight: var(--fw-extrabold);
            color: var(--color-primary);
            letter-spacing: -0.5px;
        }

        .logo__badge {
            font-size: var(--text-xs);
            font-weight: var(--fw-regular);
            color: var(--color-grey-500);
            margin-left: var(--space-1);
        }

        .nav__list {
            list-style: none;
            display: flex;
            align-items: center;
            gap: var(--space-6);
        }

        .nav__link {
            font-size: var(--text-sm);
            font-weight: var(--fw-medium);
            color: var(--color-grey-700);
            transition: color var(--transition-fast);
            position: relative;
        }

        .nav__link::after {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 0;
            width: 0;
            height: 2px;
            background-color: var(--color-primary);
            border-radius: var(--radius-full);
            transition: width var(--transition-base);
        }

        .nav__link:hover,
        .nav__link:focus {
            color: var(--color-primary);
        }

        .nav__link:hover::after,
        .nav__link:focus::after {
            width: 100%;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: var(--space-2);
            font-size: var(--text-sm);
            font-weight: var(--fw-semibold);
            border: none;
            border-radius: var(--radius-sm);
            padding: var(--space-2) var(--space-5);
            transition: all var(--transition-base);
            line-height: var(--line-height-normal);
        }

        .btn--primary {
            background: linear-gradient(135deg, var(--color-primary), var(--color-primary-dark));
            color: #fff;
            box-shadow: 0 2px 8px rgba(233, 69, 96, 0.3);
        }

        .btn--primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 16px rgba(233, 69, 96, 0.4);
        }

        .btn--primary:active {
            transform: translateY(0);
            box-shadow: 0 1px 4px rgba(233, 69, 96, 0.2);
        }

        /* ============================================================
           HERO
           ============================================================ */
        .hero {
            position: relative;
            background: linear-gradient(135deg, var(--color-dark-2) 0%, var(--color-dark-3) 40%, var(--color-dark) 100%);
            color: #fff;
            padding: var(--space-10) 0;
            text-align: center;
            overflow: hidden;
        }

        .hero__bg {
            position: absolute;
            inset: -50%;
            background: radial-gradient(circle at 50% 50%, rgba(233, 69, 96, 0.08) 0%, transparent 60%),
                        radial-gradient(circle at 80% 20%, rgba(255, 159, 67, 0.06) 0%, transparent 50%);
            animation: heroPulse 8s ease-in-out infinite;
        }

        @keyframes heroPulse {
            0%, 100% { transform: scale(1) rotate(0deg); }
            50% { transform: scale(1.06) rotate(0.5deg); }
        }

        .hero__content {
            position: relative;
            z-index: 1;
        }

        .hero__title {
            font-family: var(--font-display), var(--font-cjk);
            font-size: var(--text-4xl);
            font-weight: var(--fw-extrabold);
            line-height: var(--line-height-tight);
            letter-spacing: -1px;
            margin-bottom: var(--space-5);
        }

        .hero__title span {
            color: var(--color-primary);
            position: relative;
        }

        .hero__title span::after {
            content: '';
            position: absolute;
            bottom: 2px;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--color-primary), var(--color-accent));
            border-radius: var(--radius-full);
            opacity: 0.3;
        }

        .hero__description {
            font-size: var(--text-md);
            color: var(--color-grey-400);
            max-width: 56rem;
            margin: 0 auto var(--space-7);
            line-height: var(--line-height-relaxed);
        }

        .hero__badges {
            display: flex;
            gap: var(--space-4);
            justify-content: center;
            flex-wrap: wrap;
        }

        .badge {
            display: flex;
            align-items: center;
            gap: var(--space-2);
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: var(--radius-xl);
            padding: var(--space-3) var(--space-5);
            font-size: var(--text-sm);
            font-weight: var(--fw-medium);
            backdrop-filter: blur(10px);
            transition: all var(--transition-base);
        }

        .badge:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }

        .badge__icon {
            font-size: var(--text-lg);
        }

        /* ============================================================
           FEATURES
           ============================================================ */
        .features {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: var(--space-5);
            max-width: var(--max-width);
            margin: 0 auto;
            padding: 0 var(--space-5);
        }

        .feature {
            background: #fff;
            border-radius: var(--radius-md);
            padding: var(--space-6) var(--space-5);
            text-align: center;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--color-grey-200);
            transition: all var(--transition-slow);
            position: relative;
            overflow: hidden;
        }

        .feature::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--color-primary), var(--color-accent));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform var(--transition-slow);
        }

        .feature:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-xl);
            border-color: transparent;
        }

        .feature:hover::before {
            transform: scaleX(1);
        }

        .feature__icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 6.4rem;
            height: 6.4rem;
            border-radius: var(--radius-lg);
            font-size: var(--text-2xl);
            margin-bottom: var(--space-4);
            transition: transform var(--transition-base);
        }

        .feature:hover .feature__icon {
            transform: scale(1.1);
        }

        .feature__icon--fresh { background-color: #fff0f0; }
        .feature__icon--delivery { background-color: #f0f4ff; }
        .feature__icon--price { background-color: #f0fff0; }
        .feature__icon--service { background-color: #fff8f0; }

        .feature__title {
            font-size: var(--text-md);
            font-weight: var(--fw-bold);
            color: var(--color-grey-900);
            margin-bottom: var(--space-2);
        }

        .feature__text {
            font-size: var(--text-sm);
            color: var(--color-grey-500);
            line-height: var(--line-height-relaxed);
        }

        /* ============================================================
           PRODUCT SECTION
           ============================================================ */
        .catalog {
            display: grid;
            grid-template-columns: 1fr 36rem;
            gap: var(--space-5);
            max-width: var(--max-width);
            margin: 0 auto;
            padding: 0 var(--space-5);
            align-items: start;
        }

        /* ---- Search ---- */
        .search {
            position: relative;
            margin-bottom: var(--space-5);
        }

        .search__input {
            width: 100%;
            padding: var(--space-3) var(--space-4);
            padding-left: 4.4rem;
            font-size: var(--text-sm);
            border: 2px solid var(--color-grey-200);
            border-radius: var(--radius-md);
            background-color: #fff;
            color: var(--color-grey-800);
            transition: all var(--transition-base);
            outline: none;
        }

        .search__input::placeholder {
            color: var(--color-grey-400);
        }

        .search__input:focus {
            border-color: var(--color-primary);
            box-shadow: var(--shadow-glow);
        }

        .search__icon {
            position: absolute;
            left: var(--space-4);
            top: 50%;
            transform: translateY(-50%);
            font-size: var(--text-md);
            pointer-events: none;
        }

        /* ---- Alert / Message ---- */
        .alert {
            padding: var(--space-3) var(--space-4);
            border-radius: var(--radius-sm);
            font-size: var(--text-sm);
            font-weight: var(--fw-medium);
            margin-bottom: var(--space-4);
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }

        .alert--success {
            background-color: var(--color-success-light);
            color: #1e8449;
            border: 1px solid #a9dfbf;
        }

        .alert--error {
            background-color: var(--color-error-light);
            color: #c0392b;
            border: 1px solid #f5b7b1;
        }

        /* ---- Product Grid ---- */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(22rem, 1fr));
            gap: var(--space-4);
        }

        .product-card {
            background: #fff;
            border-radius: var(--radius-md);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--color-grey-200);
            transition: all var(--transition-slow);
            display: flex;
            flex-direction: column;
        }

        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: var(--color-primary-light);
        }

        .product-card--disabled {
            opacity: 0.45;
            cursor: not-allowed;
            pointer-events: none;
        }

        .product-card__image {
            height: 18rem;
            background: var(--color-grey-50);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .product-card__image img {
            max-width: 75%;
            max-height: 75%;
            object-fit: contain;
            transition: transform var(--transition-slow);
        }

        .product-card:hover .product-card__image img {
            transform: scale(1.06);
        }

        .product-card__placeholder {
            font-size: 4.8rem;
            color: var(--color-grey-300);
        }

        .product-card__body {
            padding: var(--space-3) var(--space-4);
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .product-card__name {
            font-size: var(--text-sm);
            font-weight: var(--fw-semibold);
            color: var(--color-grey-900);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: var(--space-1);
        }

        .product-card__meta {
            font-size: var(--text-xs);
            color: var(--color-grey-400);
            margin-bottom: var(--space-2);
        }

        .product-card__footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 var(--space-4) var(--space-4);
        }

        .product-card__price {
            font-size: var(--text-xl);
            font-weight: var(--fw-extrabold);
            color: var(--color-primary);
            line-height: 1;
        }

        .product-card__price-unit {
            font-size: var(--text-sm);
            font-weight: var(--fw-regular);
        }

        .product-card__add {
            width: 3.4rem;
            height: 3.4rem;
            border-radius: var(--radius-full);
            background: var(--color-primary);
            color: #fff;
            border: none;
            font-size: var(--text-lg);
            font-weight: var(--fw-bold);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all var(--transition-base);
            box-shadow: 0 2px 8px rgba(233, 69, 96, 0.25);
            flex-shrink: 0;
        }

        .product-card__add:hover {
            background: var(--color-primary-dark);
            transform: scale(1.1);
            box-shadow: 0 4px 14px rgba(233, 69, 96, 0.4);
        }

        /* ---- Empty State ---- */
        .empty-state {
            text-align: center;
            padding: var(--space-8) var(--space-5);
            color: var(--color-grey-400);
        }

        .empty-state__icon {
            font-size: 4.8rem;
            margin-bottom: var(--space-4);
        }

        .empty-state__text {
            font-size: var(--text-md);
        }

        /* ============================================================
           CART PANEL
           ============================================================ */
        .cart {
            background: #fff;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            border: 1px solid var(--color-grey-200);
            padding: var(--space-5);
            position: sticky;
            top: calc(var(--header-height) + var(--space-5));
            max-height: calc(100vh - var(--header-height) - var(--space-10));
            display: flex;
            flex-direction: column;
        }

        .cart__header {
            display: flex;
            align-items: center;
            gap: var(--space-2);
            margin-bottom: var(--space-4);
            padding-bottom: var(--space-4);
            border-bottom: 1px solid var(--color-grey-200);
        }

        .cart__title {
            font-size: var(--text-md);
            font-weight: var(--fw-bold);
            color: var(--color-grey-900);
        }

        .cart__badge {
            font-size: var(--text-xs);
            font-weight: var(--fw-medium);
            color: var(--color-grey-500);
            margin-left: auto;
        }

        .cart__items {
            overflow-y: auto;
            flex: 1;
            min-height: 0;
        }

        .cart-item {
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: var(--space-3);
            align-items: center;
            padding: var(--space-3) 0;
            border-bottom: 1px solid var(--color-grey-100);
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .cart-item__info {
            min-width: 0;
        }

        .cart-item__name {
            font-size: var(--text-sm);
            font-weight: var(--fw-medium);
            color: var(--color-grey-800);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .cart-item__meta {
            font-size: var(--text-xs);
            color: var(--color-grey-500);
        }

        .cart-item__qty {
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }

        .cart-item__qty-btn {
            width: 2.6rem;
            height: 2.6rem;
            border-radius: var(--radius-xs);
            border: 1px solid var(--color-grey-300);
            background: #fff;
            font-size: var(--text-sm);
            font-weight: var(--fw-semibold);
            color: var(--color-grey-700);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all var(--transition-fast);
            line-height: 1;
            cursor: pointer;
        }

        .cart-item__qty-btn:hover {
            border-color: var(--color-primary);
            color: var(--color-primary);
            background: var(--color-primary-bg);
        }

        .cart-item__qty-value {
            font-size: var(--text-sm);
            font-weight: var(--fw-semibold);
            color: var(--color-grey-800);
            min-width: 2.4rem;
            text-align: center;
        }

        .cart-item__subtotal {
            font-size: var(--text-sm);
            font-weight: var(--fw-bold);
            color: var(--color-primary);
            white-space: nowrap;
        }

        /* ---- Cart Empty ---- */
        .cart-empty {
            text-align: center;
            padding: var(--space-6) var(--space-4);
            color: var(--color-grey-400);
        }

        .cart-empty__icon {
            font-size: 4rem;
            margin-bottom: var(--space-3);
            opacity: 0.6;
        }

        .cart-empty__text {
            font-size: var(--text-sm);
            line-height: var(--line-height-relaxed);
        }

        /* ---- Cart Summary ---- */
        .cart__summary {
            margin-top: auto;
            padding-top: var(--space-4);
            border-top: 2px solid var(--color-primary);
        }

        .cart__summary-row {
            display: flex;
            justify-content: space-between;
            font-size: var(--text-sm);
            color: var(--color-grey-600);
            margin-bottom: var(--space-2);
        }

        .cart__summary-total {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            font-size: var(--text-lg);
            font-weight: var(--fw-extrabold);
            color: var(--color-primary);
            margin-top: var(--space-2);
            margin-bottom: var(--space-4);
        }

        .cart__summary-label {
            font-size: var(--text-sm);
            font-weight: var(--fw-medium);
            color: var(--color-grey-700);
        }

        .btn--checkout {
            display: flex;
            width: 100%;
            padding: var(--space-3) var(--space-4);
            background: linear-gradient(135deg, var(--color-primary), var(--color-primary-dark));
            color: #fff;
            border: none;
            border-radius: var(--radius-sm);
            font-size: var(--text-md);
            font-weight: var(--fw-bold);
            cursor: pointer;
            transition: all var(--transition-base);
            box-shadow: 0 4px 14px rgba(233, 69, 96, 0.3);
            justify-content: center;
        }

        .btn--checkout:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(233, 69, 96, 0.4);
        }

        .btn--checkout:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(233, 69, 96, 0.25);
        }

        .btn--checkout:disabled {
            opacity: 0.4;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .cart__clear {
            display: block;
            text-align: center;
            margin-top: var(--space-3);
            font-size: var(--text-xs);
            color: var(--color-grey-400);
            transition: color var(--transition-fast);
            background: none;
            border: none;
        }

        .cart__clear:hover {
            color: var(--color-error);
        }

        /* ============================================================
           FOOTER
           ============================================================ */
        .footer {
            background: var(--color-dark);
            color: var(--color-grey-500);
            text-align: center;
            padding: var(--space-7) var(--space-5);
            margin-top: var(--space-9);
        }

        .footer__text {
            font-size: var(--text-sm);
            line-height: var(--line-height-relaxed);
        }

        .footer__text + .footer__text {
            margin-top: var(--space-2);
        }

        .footer__link {
            color: var(--color-primary-light);
            font-weight: var(--fw-medium);
            transition: color var(--transition-fast);
        }

        .footer__link:hover {
            color: var(--color-primary);
        }

        /* ============================================================
           ANIMATIONS
           ============================================================ */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .feature {
            animation: fadeInUp 0.6s ease backwards;
        }
        .feature:nth-child(1) { animation-delay: 0.05s; }
        .feature:nth-child(2) { animation-delay: 0.15s; }
        .feature:nth-child(3) { animation-delay: 0.25s; }
        .feature:nth-child(4) { animation-delay: 0.35s; }

        /* ============================================================
           RESPONSIVE
           ============================================================ */
        @media (max-width: 56em) {
            :root {
                --text-4xl: 3.2rem;
                --text-3xl: 2.4rem;
            }

            .catalog {
                grid-template-columns: 1fr;
            }

            .cart {
                position: static;
                max-height: none;
            }

            .features {
                grid-template-columns: repeat(2, 1fr);
            }

            .nav__list {
                gap: var(--space-4);
            }
        }

        @media (max-width: 36em) {
            :root {
                --text-4xl: 2.6rem;
                --text-3xl: 2.2rem;
            }

            .features {
                grid-template-columns: 1fr;
            }

            .product-grid {
                grid-template-columns: 1fr 1fr;
                gap: var(--space-3);
            }

            .hero {
                padding: var(--space-7) 0;
            }

            .hero__badges {
                gap: var(--space-2);
            }

            .badge {
                padding: var(--space-2) var(--space-3);
                font-size: var(--text-xs);
            }

            .nav__list {
                gap: var(--space-3);
            }

            .nav__link {
                font-size: var(--text-xs);
            }

            .logo__text {
                font-size: var(--text-md);
            }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- ========== TOP BAR ========== -->
    <div class="top-bar">
        <div class="top-bar__inner">
            <a href="#features" class="top-bar__link">关于我们</a>
            <span class="top-bar__divider">|</span>
            <a href="#products" class="top-bar__link">商品浏览</a>
            <span class="top-bar__divider">|</span>
            <a href="../Login.aspx" class="top-bar__link">登录后台</a>
        </div>
    </div>

    <!-- ========== HEADER ========== -->
    <header class="header">
        <div class="header__inner">
            <a href="#" class="logo">
                <span class="logo__icon">🏠</span>
                <span class="logo__text">便民超市</span>
                <span class="logo__badge">.com</span>
            </a>
            <nav>
                <ul class="nav__list">
                    <li><a href="#features" class="nav__link">服务特色</a></li>
                    <li><a href="#products" class="nav__link">全部商品</a></li>
                    <li><a href="#cart" class="nav__link">购物车</a></li>
                    <li><a href="../Login.aspx" class="btn btn--primary">登录后台</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- ========== HERO ========== -->
    <section class="hero">
        <div class="hero__bg"></div>
        <div class="hero__content container">
            <h1 class="hero__title">欢迎来到<span>便民超市</span></h1>
            <p class="hero__description">
                品质生活，触手可及。我们精选千款好物，以最优价格、最快配送，服务每一位邻居。线上线下同步，让购物变得更简单。
            </p>
            <div class="hero__badges">
                <div class="badge"><span class="badge__icon">🚚</span>30分钟送达</div>
                <div class="badge"><span class="badge__icon">🌿</span>新鲜直供</div>
                <div class="badge"><span class="badge__icon">💰</span>天天低价</div>
                <div class="badge"><span class="badge__icon">⭐</span>品质保证</div>
            </div>
        </div>
    </section>

    <!-- ========== FEATURES ========== -->
    <section class="section" id="features">
        <div class="section__header">
            <h2 class="section__title">为什么选择我们</h2>
            <p class="section__subtitle">用心服务每一位顾客，让购物变成享受</p>
        </div>
        <div class="features">
            <article class="feature">
                <div class="feature__icon feature__icon--fresh">🌿</div>
                <h3 class="feature__title">新鲜食材</h3>
                <p class="feature__text">每日新鲜到货，严格品控，从源头保障品质</p>
            </article>
            <article class="feature">
                <div class="feature__icon feature__icon--delivery">🚚</div>
                <h3 class="feature__title">极速配送</h3>
                <p class="feature__text">下单30分钟内送达，专业冷链，新鲜不等待</p>
            </article>
            <article class="feature">
                <div class="feature__icon feature__icon--price">💰</div>
                <h3 class="feature__title">实惠价格</h3>
                <p class="feature__text">厂家直供，减少中间环节，把实惠留给您</p>
            </article>
            <article class="feature">
                <div class="feature__icon feature__icon--service">📞</div>
                <h3 class="feature__title">贴心服务</h3>
                <p class="feature__text">7x24小时客服，退换无忧，您的满意是我们的追求</p>
            </article>
        </div>
    </section>

    <!-- ========== PRODUCTS ========== -->
    <section class="section section--grey" id="products">
        <div class="section__header">
            <h2 class="section__title">精选商品</h2>
            <p class="section__subtitle">点击商品卡片即可加入购物车</p>
        </div>

        <div class="catalog">

            <!-- Main: Product Listing -->
            <div class="catalog__main">
                <div class="search">
                    <span class="search__icon">🔍</span>
                    <asp:TextBox
                        ID="txtSearch"
                        runat="server"
                        CssClass="search__input"
                        placeholder="搜索商品名称或编码..."
                        AutoPostBack="true"
                        OnTextChanged="TxtSearch_TextChanged" />
                </div>

                <asp:Literal ID="litMsg" runat="server" />

                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="RptProducts_ItemCommand">
                    <HeaderTemplate><div class="product-grid"></HeaderTemplate>
                    <ItemTemplate>
                        <asp:LinkButton
                            ID="lnkCard"
                            runat="server"
                            CssClass='<%# (int)Eval("StockQuantity") <= 0 ? "product-card product-card--disabled" : "product-card" %>'
                            CommandName="Add"
                            CommandArgument='<%# Eval("Id") %>'
                            Enabled='<%# (int)Eval("StockQuantity") > 0 %>'>
                            <div class="product-card__image">
                                <asp:Image
                                    ID="imgProduct"
                                    runat="server"
                                    ImageUrl='<%# Eval("ImagePath") %>'
                                    Visible='<%# !string.IsNullOrEmpty((string)Eval("ImagePath")) %>' />
                                <span class="product-card__placeholder"
                                    Visible='<%# string.IsNullOrEmpty((string)Eval("ImagePath")) %>'
                                    runat="server">&#128230;</span>
                            </div>
                            <div class="product-card__body">
                                <div class="product-card__name"><%# Eval("Name") %></div>
                                <div class="product-card__meta"><%# Eval("Code") %> · 库存 <%# Eval("StockQuantity") %></div>
                            </div>
                            <div class="product-card__footer">
                                <span class="product-card__price">
                                    <span class="product-card__price-unit">¥</span><%# Eval("SellingPrice","{0:F2}") %>
                                </span>
                                <span class="product-card__add">+</span>
                            </div>
                        </asp:LinkButton>
                    </ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoProducts" runat="server" Visible="false" CssClass="empty-state">
                    <div class="empty-state__icon">📦</div>
                    <div class="empty-state__text">暂无商品</div>
                </asp:Panel>
            </div>

            <!-- Side: Cart -->
            <aside class="cart" id="cart">
                <div class="cart__header">
                    <span class="cart__title">🛒 购物车</span>
                    <span class="cart__badge">(<%# CartHelper.Count %>件)</span>
                </div>

                <div class="cart__items">
                    <asp:Repeater ID="rptCart" runat="server" OnItemCommand="RptCart_ItemCommand">
                        <ItemTemplate>
                            <div class="cart-item">
                                <div class="cart-item__info">
                                    <div class="cart-item__name"><%# Eval("ProductName") %></div>
                                    <div class="cart-item__meta">¥<%# Eval("UnitPrice","{0:F2}") %> &times; <%# Eval("Quantity") %></div>
                                </div>
                                <div class="cart-item__qty">
                                    <asp:LinkButton
                                        ID="btnMinus"
                                        runat="server"
                                        Text="-"
                                        CommandName="Minus"
                                        CommandArgument='<%# Eval("ProductId") %>'
                                        CssClass="cart-item__qty-btn" />
                                    <span class="cart-item__qty-value"><%# Eval("Quantity") %></span>
                                    <asp:LinkButton
                                        ID="btnPlus"
                                        runat="server"
                                        Text="+"
                                        CommandName="Plus"
                                        CommandArgument='<%# Eval("ProductId") %>'
                                        CssClass="cart-item__qty-btn" />
                                </div>
                                <span class="cart-item__subtotal">¥<%# Eval("SubTotal","{0:F2}") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlCartEmpty" runat="server" Visible="true">
                        <div class="cart-empty">
                            <div class="cart-empty__icon">🛒</div>
                            <div class="cart-empty__text">
                                购物车是空的<br/>
                                点击商品卡片添加吧 😊
                            </div>
                        </div>
                    </asp:Panel>
                </div>

                <div class="cart__summary">
                    <div class="cart__summary-row">
                        <span>商品总额</span>
                        <span>¥<asp:Literal ID="litSubtotal" runat="server" Text="0.00" /></span>
                    </div>
                    <div class="cart__summary-row">
                        <span>数量</span>
                        <span><asp:Literal ID="litItemCount" runat="server" Text="0" /> 件</span>
                    </div>
                    <div class="cart__summary-total">
                        <span class="cart__summary-label">合计</span>
                        <span>¥<asp:Literal ID="litTotal" runat="server" Text="0.00" /></span>
                    </div>
                    <asp:Button
                        ID="btnCheckout"
                        runat="server"
                        Text="去结算"
                        CssClass="btn--checkout"
                        OnClick="BtnCheckout_Click"
                        OnClientClick="return confirm('确定结算当前购物车？')" />
                    <asp:LinkButton
                        ID="btnClear"
                        runat="server"
                        Text="清空购物车"
                        OnClick="BtnClear_Click"
                        CssClass="cart__clear" />
                </div>
            </aside>

        </div>
    </section>

    <!-- ========== FOOTER ========== -->
    <footer class="footer">
        <p class="footer__text">
            &copy; 2025 便民超市 ErpManagement &middot;
            <a href="../Login.aspx" class="footer__link">管理后台</a>
        </p>
        <p class="footer__text">
            地址：xx市xx区xx路100号 | 电话：400-888-8888 | 营业时间：07:00 - 22:00
        </p>
    </footer>

</form>
</body>
</html>
