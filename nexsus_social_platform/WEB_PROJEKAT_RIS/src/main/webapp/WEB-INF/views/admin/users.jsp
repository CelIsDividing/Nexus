<%@ include file="../layout.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="Admin Panel" />
<link href="<c:url value='/css/admin.css' />" rel="stylesheet">
<style>
    .admin-wrap { max-width: 1000px; margin: 28px auto; padding: 0 16px 40px; }
    .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
    .admin-title { color: var(--text); font-size: 1.5rem; font-weight: 700; margin: 0; }
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px,1fr)); gap: 16px; margin-bottom: 24px; }
    .stat-card {
        background: var(--bg-card); border: 1px solid var(--border); border-radius: 14px;
        padding: 20px 24px; text-align: center;
    }
    .stat-number { font-size: 2rem; font-weight: 800; color: var(--primary-h); }
    .stat-label { color: var(--text-3); font-size: 0.85rem; margin-top: 4px; }
    .admin-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; margin-bottom: 20px; }
    .card-header { padding: 16px 20px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px; }
    .card-header h5 { color: var(--text); font-size: 1rem; font-weight: 700; margin: 0; display: flex; align-items: center; gap: 8px; }
    .card-header h5 i { color: var(--primary-h); }
    .card-body { padding: 20px; }
    .report-actions p { color: var(--text-2); margin-bottom: 12px; font-size: 0.9rem; }
    .btn-primary {
        background: linear-gradient(135deg, var(--primary), var(--primary-h));
        border: none; border-radius: 8px; padding: 8px 18px;
        color: white; font-weight: 600; font-size: 0.875rem; text-decoration: none;
        display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s;
    }
    .btn-primary:hover { opacity: 0.9; color: white; }
    .alert { padding: 12px 16px; border-radius: 10px; margin-bottom: 16px; font-size: 0.9rem; display: flex; align-items: center; gap: 8px; }
    .alert-success { background: rgba(16,185,129,0.12); color: #10b981; border: 1px solid rgba(16,185,129,0.25); }
    .alert-danger { background: rgba(239,68,68,0.12); color: var(--danger); border: 1px solid rgba(239,68,68,0.25); }
    .table-responsive { overflow-x: auto; }
    .users-table { width: 100%; border-collapse: collapse; }
    .users-table th { color: var(--text-3); font-size: 0.8rem; font-weight: 700; padding: 10px 16px; text-align: left; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); }
    .users-table td { padding: 14px 16px; border-bottom: 1px solid var(--border); vertical-align: middle; }
    .users-table tr:last-child td { border-bottom: none; }
    .users-table tr:hover td { background: var(--hover); }
    .users-table tr.current-user td { background: rgba(124,58,237,0.06); }
    .user-info { display: flex; align-items: center; gap: 10px; }
    .user-avatar {
        width: 36px; height: 36px; border-radius: 50%; flex-shrink: 0;
        background: linear-gradient(135deg, var(--primary), var(--accent));
        display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: 0.95rem; color: white; text-transform: uppercase;
    }
    .username { color: var(--text); font-weight: 600; font-size: 0.9rem; }
    .user-id { color: var(--text-3); font-size: 0.85rem; font-weight: 600; }
    .user-email { color: var(--text-2); font-size: 0.875rem; }
    .you-badge { font-size: 0.75rem; color: var(--primary-h); font-weight: 600; margin-top: 2px; }
    .btn-danger {
        background: rgba(239,68,68,0.12); border: 1px solid rgba(239,68,68,0.3);
        border-radius: 8px; padding: 6px 14px; color: var(--danger); font-weight: 600;
        font-size: 0.8rem; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 5px;
    }
    .btn-danger:hover { background: rgba(239,68,68,0.22); }
    .empty-state { text-align: center; padding: 48px 24px; }
    .empty-icon { font-size: 3rem; color: var(--border); margin-bottom: 12px; }
    .empty-title { color: var(--text-2); font-size: 1.1rem; font-weight: 700; margin-bottom: 6px; }
    .empty-subtitle { color: var(--text-3); font-size: 0.875rem; }
    /* Modal overrides */
    .modal-content { background: var(--bg-card); border: 1px solid var(--border); color: var(--text); }
    .modal-header { border-bottom: 1px solid var(--border); }
    .modal-footer { border-top: 1px solid var(--border); }
    .modal-title { color: var(--text); font-weight: 700; }
    .btn-secondary { background: var(--bg-surface); border: 1px solid var(--border); color: var(--text-2); padding: 8px 18px; border-radius: 8px; font-weight: 600; cursor: pointer; }
    .btn-secondary:hover { border-color: var(--text-3); }
    .btn-close-white { filter: invert(1); }
</style>
</head>
<body>
    <div class="admin-wrap">
        <div class="admin-header">
            <h1 class="admin-title"><i class="fas fa-shield-halved" style="color:var(--primary-h);margin-right:10px"></i>Admin Panel</h1>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${users.size()}</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${users.size()}</div>
                <div class="stat-label">Active Users</div>
            </div>
        </div>

        <div class="admin-card">
            <div class="card-header">
                <h5><i class="fas fa-file-pdf"></i> Reports</h5>
            </div>
            <div class="card-body">
                <div class="report-actions">
                    <p>Download user reports in PDF format:</p>
                    <a href="<c:url value='/getUsersReport.pdf?clearance=ALL' />" class="btn-primary" target="_blank">
                        <i class="fas fa-download"></i> All Users PDF
                    </a>
                </div>
            </div>
        </div>

        <div class="admin-card">
            <div class="card-header">
                <h5><i class="fas fa-users-gear"></i> System Users</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>${error}
                    </div>
                </c:if>
                <c:if test="${empty users}">
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fas fa-users-slash"></i></div>
                        <h3 class="empty-title">No Users Found</h3>
                        <p class="empty-subtitle">No registered users yet.</p>
                    </div>
                </c:if>
                <c:if test="${not empty users}">
                    <div class="table-responsive">
                        <table class="users-table">
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>ID</th>
                                    <th>Email</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${users}" var="user">
                                    <tr class="${user.id == currentUser.id ? 'current-user' : ''}">
                                        <td>
                                            <div class="user-info">
                                                <div class="user-avatar">${user.username.charAt(0)}</div>
                                                <div>
                                                    <div class="username">${user.username}</div>
                                                    <c:if test="${user.id == currentUser.id}">
                                                        <div class="you-badge">You</div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td><div class="user-id">#${user.id}</div></td>
                                        <td><div class="user-email">${user.email}</div></td>
                                        <td>
                                            <c:if test="${user.id != currentUser.id}">
                                                <button type="button" class="btn-danger delete-user-btn"
                                                    data-user-id="${user.id}"
                                                    data-user-name="${user.username}">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </c:if>
                                            <c:if test="${user.id == currentUser.id}">
                                                <span style="color:var(--text-3);font-size:0.85rem">â€”</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteUserModalLabel">
                        <i class="fas fa-triangle-exclamation" style="color:var(--danger);margin-right:8px"></i>Confirm Deletion
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="color:var(--text-2)">
                    <p>Delete user <strong id="userNameToDelete" style="color:var(--text)"></strong>?</p>
                    <p style="color:var(--danger);margin:0;font-size:0.9rem"><i class="fas fa-exclamation-circle"></i> This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn-danger" id="confirmDeleteBtn" style="padding:8px 18px">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const modal = new bootstrap.Modal(document.getElementById('deleteUserModal'));
        const userNameEl = document.getElementById('userNameToDelete');
        const confirmBtn = document.getElementById('confirmDeleteBtn');
        let userId = null;
        const csrfToken = '${_csrf.token}';
        const csrfParam = '${_csrf.parameterName}';
        const baseUrl = '<c:url value="/admin/users/delete/" />';

        document.querySelectorAll('.delete-user-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                userId = this.getAttribute('data-user-id');
                userNameEl.textContent = this.getAttribute('data-user-name');
                modal.show();
            });
        });

        confirmBtn.addEventListener('click', function() {
            if (!userId) return;
            const orig = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
            this.disabled = true;
            const body = new URLSearchParams();
            body.append(csrfParam, csrfToken);
            fetch(baseUrl + userId, { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: body })
                .then(r => { if (r.redirected || r.ok) window.location.reload(); else throw new Error(r.status); })
                .catch(e => { this.innerHTML = orig; this.disabled = false; alert('Error: ' + e.message); });
        });

        document.getElementById('deleteUserModal').addEventListener('hidden.bs.modal', function() {
            confirmBtn.innerHTML = '<i class="fas fa-trash"></i> Delete';
            confirmBtn.disabled = false;
            userId = null;
        });

        document.querySelectorAll('.alert').forEach(a => setTimeout(() => a.remove(), 5000));
    });
    </script>
</body>
</html>
