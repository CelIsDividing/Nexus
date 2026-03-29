<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account â€” Nexus</title>
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
            display: flex; align-items: center; justify-content: center;
            padding: 20px;
        }
        body::before {
            content: '';
            position: fixed; inset: 0;
            background: radial-gradient(ellipse at 80% 50%, rgba(124,58,237,0.15) 0%, transparent 60%),
                        radial-gradient(ellipse at 20% 80%, rgba(6,182,212,0.1) 0%, transparent 50%);
            pointer-events: none;
        }
        .register-wrapper { width: 100%; max-width: 460px; position: relative; z-index: 1; }
        .brand { text-align: center; margin-bottom: 28px; }
        .brand-logo {
            display: inline-flex; align-items: center; gap: 12px;
            font-weight: 800; font-size: 1.8rem; letter-spacing: -1px;
            color: var(--primary-h); text-decoration: none;
        }
        .brand-logo i { color: var(--accent); }
        .register-card {
            background: var(--bg-card); border: 1px solid var(--border);
            border-radius: 20px; padding: 36px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
        }
        .card-title { font-size: 1.4rem; font-weight: 700; margin-bottom: 6px; }
        .card-subtitle { color: var(--text-2); font-size: 0.875rem; margin-bottom: 28px; }
        .form-group { margin-bottom: 16px; }
        .form-label {
            display: block; font-size: 0.78rem; font-weight: 600;
            color: var(--text-2); margin-bottom: 6px;
            text-transform: uppercase; letter-spacing: 0.05em;
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
        .strength-bar-wrap {
            height: 4px; background: var(--border); border-radius: 999px;
            margin-top: 8px; overflow: hidden;
        }
        .strength-bar {
            height: 100%; width: 0; border-radius: 999px;
            transition: width 0.3s, background 0.3s;
        }
        .strength-weak   { width: 33%; background: var(--danger); }
        .strength-medium { width: 66%; background: var(--accent); }
        .strength-strong { width: 100%; background: var(--green); }
        .requirements { margin-top: 10px; display: flex; flex-direction: column; gap: 4px; }
        .req-item { font-size: 0.78rem; color: var(--text-3); display: flex; align-items: center; gap: 6px; }
        .req-item.valid { color: var(--green-h); }
        .req-item.invalid { color: var(--danger-h); }
        .alert {
            padding: 12px 14px; border-radius: 10px; font-size: 0.875rem;
            margin-bottom: 16px; display: flex; align-items: center; gap: 8px;
        }
        .alert-danger  { background: rgba(239,68,68,0.12); color: var(--danger-h); border: 1px solid rgba(239,68,68,0.2); }
        .alert-success { background: rgba(16,185,129,0.12); color: var(--green-h); border: 1px solid rgba(16,185,129,0.2); }
        .btn-register {
            width: 100%; padding: 13px;
            background: linear-gradient(135deg, var(--primary), var(--primary-h));
            border: none; border-radius: 10px; color: white;
            font-weight: 700; font-size: 0.95rem; cursor: pointer;
            transition: all 0.2s; font-family: inherit; letter-spacing: 0.02em;
        }
        .btn-register:hover { opacity: 0.9; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(124,58,237,0.4); }
        .divider {
            display: flex; align-items: center; gap: 12px;
            margin: 24px 0; color: var(--text-3); font-size: 0.8rem;
        }
        .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: var(--border); }
        .login-link { text-align: center; }
        .login-link a {
            color: var(--primary-h); text-decoration: none; font-weight: 600; font-size: 0.9rem;
            display: inline-flex; align-items: center; gap: 6px; transition: color 0.2s;
        }
        .login-link a:hover { color: var(--accent); }
    </style>
</head>
<body>
    <div class="register-wrapper">
        <div class="brand">
            <a href="#" class="brand-logo">
                <i class="fas fa-bolt"></i> Nexus
            </a>
        </div>

        <div class="register-card">
            <h2 class="card-title">Create your account</h2>
            <p class="card-subtitle">Join Nexus and start connecting today</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="fas fa-circle-exclamation"></i>${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success"><i class="fas fa-circle-check"></i>${success}</div>
            </c:if>

            <form method="post" id="registerForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-input" required
                           placeholder="Choose a username" id="username">
                </div>

                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-input" required
                           placeholder="your@email.com" id="email">
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-input" required
                           placeholder="Create a strong password" id="password">
                    <div class="strength-bar-wrap">
                        <div class="strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="requirements">
                        <div class="req-item" id="reqLength"><i class="fas fa-circle"></i> At least 8 characters</div>
                        <div class="req-item" id="reqNumber"><i class="fas fa-circle"></i> Contains a number</div>
                        <div class="req-item" id="reqSpecial"><i class="fas fa-circle"></i> Contains a special character</div>
                    </div>
                </div>

                <button type="submit" class="btn-register" id="registerBtn">
                    Create Account
                </button>
            </form>

            <div class="divider">or</div>

            <div class="login-link">
                <a href="<c:url value='/login' />">
                    <i class="fas fa-arrow-left"></i>
                    Already have an account? Sign in
                </a>
            </div>
        </div>
    </div>

    <script>
        const passwordInput = document.getElementById('password');
        const strengthBar   = document.getElementById('strengthBar');
        const reqLength     = document.getElementById('reqLength');
        const reqNumber     = document.getElementById('reqNumber');
        const reqSpecial    = document.getElementById('reqSpecial');

        function setReq(el, ok, text) {
            el.className = 'req-item ' + (ok ? 'valid' : 'invalid');
            el.innerHTML = (ok ? '<i class="fas fa-check-circle"></i> ' : '<i class="fas fa-circle"></i> ') + text;
        }

        passwordInput.addEventListener('input', function() {
            const p = this.value;
            const hasLen     = p.length >= 8;
            const hasNum     = /\d/.test(p);
            const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(p);
            setReq(reqLength,  hasLen,     'At least 8 characters');
            setReq(reqNumber,  hasNum,     'Contains a number');
            setReq(reqSpecial, hasSpecial, 'Contains a special character');
            const strength = [hasLen, hasNum, hasSpecial].filter(Boolean).length;
            strengthBar.className = 'strength-bar' + (strength === 1 ? ' strength-weak' : strength === 2 ? ' strength-medium' : strength === 3 ? ' strength-strong' : '');
        });

        document.getElementById('registerForm').addEventListener('submit', function() {
            const btn = document.getElementById('registerBtn');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating account...';
            btn.disabled = true;
        });
    </script>
</body>
</html>
