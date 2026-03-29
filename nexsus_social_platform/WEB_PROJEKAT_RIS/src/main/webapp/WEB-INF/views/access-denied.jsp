<%@ include file="layout.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
    .access-denied-page {
        min-height: calc(100vh - 60px);
        display: flex; align-items: center; justify-content: center;
        padding: 40px 16px;
    }
    .access-denied-card {
        background: var(--bg-card); border: 1px solid var(--border);
        border-radius: 24px; padding: 48px 40px; text-align: center;
        max-width: 460px; width: 100%;
    }
    .denied-icon {
        width: 88px; height: 88px; border-radius: 50%;
        background: rgba(239,68,68,0.12); border: 2px solid rgba(239,68,68,0.3);
        display: flex; align-items: center; justify-content: center;
        margin: 0 auto 24px; font-size: 2.5rem; color: var(--danger);
        animation: pulse 2s ease-in-out infinite;
    }
    @keyframes pulse {
        0%, 100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(239,68,68,0.3); }
        50% { transform: scale(1.04); box-shadow: 0 0 0 10px rgba(239,68,68,0); }
    }
    .denied-code { color: var(--danger); font-size: 0.85rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; margin-bottom: 8px; }
    .denied-title { color: var(--text); font-size: 1.75rem; font-weight: 800; margin-bottom: 10px; }
    .denied-subtitle { color: var(--text-2); font-size: 0.95rem; line-height: 1.6; margin-bottom: 28px; }
    .denied-actions { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
    .btn-go-home {
        background: linear-gradient(135deg, var(--primary), var(--primary-h));
        border: none; border-radius: 12px; padding: 11px 24px;
        color: white; font-weight: 600; font-size: 0.95rem; text-decoration: none;
        display: inline-flex; align-items: center; gap: 8px; transition: all 0.2s;
    }
    .btn-go-home:hover { opacity: 0.9; color: white; transform: translateY(-1px); }
    .btn-go-back {
        background: var(--bg-surface); border: 1px solid var(--border);
        border-radius: 12px; padding: 11px 24px;
        color: var(--text-2); font-weight: 600; font-size: 0.95rem; text-decoration: none;
        display: inline-flex; align-items: center; gap: 8px; transition: all 0.2s; cursor: pointer;
    }
    .btn-go-back:hover { border-color: var(--text-3); color: var(--text); }
</style>
</head>
<body>
    <div class="access-denied-page">
        <div class="access-denied-card">
            <div class="denied-icon">
                <i class="fas fa-lock"></i>
            </div>
            <p class="denied-code">Error 403</p>
            <h1 class="denied-title">Access Denied</h1>
            <p class="denied-subtitle">You don't have permission to view this page. If you think this is a mistake, please contact the administrator.</p>
            <div class="denied-actions">
                <a href="<c:url value='/posts' />" class="btn-go-home">
                    <i class="fas fa-house"></i> Go Home
                </a>
                <button onclick="history.back()" class="btn-go-back">
                    <i class="fas fa-arrow-left"></i> Go Back
                </button>
            </div>
        </div>
    </div>
</body>
</html>
