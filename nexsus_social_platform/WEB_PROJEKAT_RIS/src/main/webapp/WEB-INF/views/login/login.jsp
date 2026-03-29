<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In â€” Nexus</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg: #0c0c1a; --bg-card: #13131f; --bg-surface: #1a1a2d;
            --primary: #7c3aed; --primary-h: #8b5cf6; --primary-d: #6d28d9;
            --accent: #06b6d4; --text: #e2e8f0; --text-2: #94a3b8; --text-3: #64748b;
            --border: #272740; --danger: #ef4444; --danger-h: #f87171;
            --green: #10b981; --green-h: #34d399;
        }
        body {
            background: var(--bg);
            font-family: 'Inter', -apple-system, sans-serif;
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        body::before {
            content: '';
            position: fixed; inset: 0;
            background: radial-gradient(ellipse at 20% 50%, rgba(124,58,237,0.15) 0%, transparent 60%),
                        radial-gradient(ellipse at 80% 20%, rgba(6,182,212,0.1) 0%, transparent 50%);
            pointer-events: none;
        }
        .login-wrapper {
            width: 100%; max-width: 420px;
            position: relative; z-index: 1;
        }
        .brand {
            text-align: center; margin-bottom: 32px;
        }
        .brand-logo {
            display: inline-flex; align-items: center; gap: 12px;
            font-weight: 800; font-size: 2rem; letter-spacing: -1px;
            color: var(--primary-h);
            text-decoration: none;
        }
        .brand-logo i { color: var(--accent); font-size: 1.8rem; }
        .brand-tagline {
            color: var(--text-3); font-size: 0.875rem; margin-top: 6px;
        }
        .login-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 36px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
        }
        .card-title {
            font-size: 1.4rem; font-weight: 700;
            margin-bottom: 6px; color: var(--text);
        }
        .card-subtitle {
            color: var(--text-2); font-size: 0.875rem; margin-bottom: 28px;
        }
        .form-group { margin-bottom: 16px; }
        .form-label {
            display: block; font-size: 0.8rem; font-weight: 600;
            color: var(--text-2); margin-bottom: 6px; text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .form-input {
            width: 100%; padding: 12px 14px;
            background: var(--bg-surface); border: 1px solid var(--border);
            border-radius: 10px; color: var(--text); font-size: 0.9rem;
            transition: all 0.2s; outline: none; font-family: inherit;
        }
        .form-input::placeholder { color: var(--text-3); }
        .form-input:focus {
            border-color: var(--primary); background: #1e1e35;
            box-shadow: 0 0 0 3px rgba(124,58,237,0.2);
        }
        .alert {
            padding: 12px 14px; border-radius: 10px;
            font-size: 0.875rem; margin-bottom: 16px;
            display: flex; align-items: center; gap: 8px;
        }
        .alert-danger { background: rgba(239,68,68,0.12); color: var(--danger-h); border: 1px solid rgba(239,68,68,0.2); }
        .alert-success { background: rgba(16,185,129,0.12); color: var(--green-h); border: 1px solid rgba(16,185,129,0.2); }
        .btn-login {
            width: 100%; padding: 13px;
            background: linear-gradient(135deg, var(--primary), var(--primary-h));
            border: none; border-radius: 10px;
            color: white; font-weight: 700; font-size: 0.95rem;
            cursor: pointer; transition: all 0.2s;
            font-family: inherit; letter-spacing: 0.02em;
        }
        .btn-login:hover { opacity: 0.9; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(124,58,237,0.4); }
        .btn-login:active { transform: translateY(0); }
        .divider {
            display: flex; align-items: center; gap: 12px;
            margin: 24px 0; color: var(--text-3); font-size: 0.8rem;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1; height: 1px; background: var(--border);
        }
        .register-link {
            text-align: center;
        }
        .register-link a {
            color: var(--primary-h); text-decoration: none; font-weight: 600;
            font-size: 0.9rem; display: inline-flex; align-items: center; gap: 6px;
            transition: color 0.2s;
        }
        .register-link a:hover { color: var(--accent); }
    </style>
</head>
<body>
    <div class="login-wrapper">
        <div class="brand">
            <a href="#" class="brand-logo">
                <i class="fas fa-bolt"></i>
                Nexus
            </a>
            <p class="brand-tagline">Connect, share, and discover</p>
        </div>

        <div class="login-card">
            <h2 class="card-title">Welcome back</h2>
            <p class="card-subtitle">Sign in to your account to continue</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-circle-exclamation"></i>${error}
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-circle-check"></i>${success}
                </div>
            </c:if>

            <form method="post" id="loginForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-input" required
                           placeholder="Enter your username">
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-input" required
                           placeholder="Enter your password">
                </div>

                <button type="submit" class="btn-login" id="loginBtn">
                    Sign In
                </button>
            </form>

            <div class="divider">or</div>

            <div class="register-link">
                <a href="<c:url value='/register' />">
                    <i class="fas fa-user-plus"></i>
                    Create a new account
                </a>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function() {
            const btn = document.getElementById('loginBtn');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Signing in...';
            btn.disabled = true;
        });
    </script>
</body>
</html>
