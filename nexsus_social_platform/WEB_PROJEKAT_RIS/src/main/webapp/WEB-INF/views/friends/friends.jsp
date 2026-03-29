<%@ include file="../layout.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="Connect" />

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<link href="${pageContext.request.contextPath}/css/friends.css" rel="stylesheet" type="text/css">
<style>
    .friends-main { max-width: 900px; margin: 28px auto; padding: 0 16px 40px; }
    .page-title { color: var(--text); font-size: 1.5rem; font-weight: 700; margin: 0 0 20px; }
    .friends-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    @media (max-width: 700px) { .friends-grid { grid-template-columns: 1fr; } }
    .friend-card {
        background: var(--bg-card); border: 1px solid var(--border);
        border-radius: 16px; overflow: hidden;
    }
    .card-header {
        padding: 16px 20px; border-bottom: 1px solid var(--border);
        display: flex; align-items: center; gap: 10px;
    }
    .card-header h5 { color: var(--text); font-size: 1rem; font-weight: 700; margin: 0; }
    .card-header i { color: var(--primary-h); }
    .card-body { padding: 8px 0; }
    .friend-item {
        display: flex; align-items: center; justify-content: space-between;
        padding: 12px 20px; gap: 12px; transition: background 0.15s;
    }
    .friend-item:hover { background: var(--hover); }
    .friend-info { display: flex; align-items: center; gap: 12px; min-width: 0; }
    .friend-avatar {
        width: 42px; height: 42px; border-radius: 50%; flex-shrink: 0;
        background: linear-gradient(135deg, var(--primary), var(--accent));
        display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: 1.1rem; color: white; text-transform: uppercase;
    }
    .friend-name { color: var(--text); font-weight: 600; font-size: 0.95rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .friend-status { color: var(--text-3); font-size: 0.8rem; margin-top: 2px; }
    .friend-actions { display: flex; gap: 8px; flex-shrink: 0; }
    .btn-confirm {
        background: linear-gradient(135deg, var(--primary), var(--primary-h));
        border: none; border-radius: 8px; padding: 7px 14px;
        color: white; font-weight: 600; font-size: 0.8rem;
        cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 5px;
    }
    .btn-confirm:hover { opacity: 0.9; }
    .btn-delete {
        background: rgba(239,68,68,0.12); border: 1px solid rgba(239,68,68,0.25);
        border-radius: 8px; padding: 7px 14px;
        color: var(--danger); font-weight: 600; font-size: 0.8rem;
        cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 5px;
    }
    .btn-delete:hover { background: rgba(239,68,68,0.2); }
    .btn-add {
        background: var(--bg-surface); border: 1px solid var(--border);
        border-radius: 8px; padding: 7px 14px;
        color: var(--text-2); font-weight: 600; font-size: 0.8rem;
        cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 5px;
    }
    .btn-add:hover { border-color: var(--primary); color: var(--primary-h); }
    .btn-message {
        background: var(--bg-surface); border: 1px solid var(--border);
        border-radius: 8px; padding: 7px 14px;
        color: var(--accent); font-weight: 600; font-size: 0.8rem;
        text-decoration: none; transition: all 0.2s; display: inline-flex; align-items: center; gap: 5px;
    }
    .btn-message:hover { border-color: var(--accent); color: var(--accent); }
    .pending-badge {
        background: rgba(245,158,11,0.15); color: #f59e0b;
        padding: 2px 8px; border-radius: 20px; font-size: 0.75rem; font-weight: 600;
    }
    .empty-state { text-align: center; padding: 32px 20px; }
    .empty-icon { font-size: 2.5rem; color: var(--border); margin-bottom: 10px; }
    .empty-title { color: var(--text-2); font-size: 0.95rem; font-weight: 600; margin-bottom: 4px; }
    .empty-subtitle { color: var(--text-3); font-size: 0.85rem; margin: 0; }
</style>
</head>
<body>
    <div class="friends-main">
        <h1 class="page-title"><i class="fas fa-users" style="color:var(--primary-h);margin-right:10px"></i>Connect</h1>
        <div class="friends-grid">
            <!-- Pending Requests -->
            <div class="friend-card">
                <div class="card-header">
                    <i class="fas fa-user-clock"></i>
                    <h5>Friend Requests</h5>
                </div>
                <div class="card-body">
                    <c:forEach items="${pendingRequests}" var="request">
                        <div class="friend-item">
                            <div class="friend-info">
                                <div class="friend-avatar">${request.idUser1.username.charAt(0)}</div>
                                <div>
                                    <div class="friend-name">${request.idUser1.username}</div>
                                    <div class="friend-status"><span class="pending-badge">Pending</span></div>
                                </div>
                            </div>
                            <div class="friend-actions">
                                <button type="button" class="btn-confirm"
                                    onclick="handleFriendRequestNoCSRF(${request.id}, 'accept')">
                                    <i class="fas fa-check"></i> Accept
                                </button>
                                <button type="button" class="btn-delete"
                                    onclick="handleFriendRequestNoCSRF(${request.id}, 'reject')">
                                    <i class="fas fa-xmark"></i>
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty pendingRequests}">
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fas fa-user-clock"></i></div>
                            <p class="empty-title">No pending requests</p>
                            <p class="empty-subtitle">New requests will appear here</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- People You May Know -->
            <div class="friend-card">
                <div class="card-header">
                    <i class="fas fa-user-plus"></i>
                    <h5>People You May Know</h5>
                </div>
                <div class="card-body">
                    <c:forEach items="${allUsers}" var="otherUser">
                        <div class="friend-item">
                            <div class="friend-info">
                                <div class="friend-avatar">${otherUser.username.charAt(0)}</div>
                                <div>
                                    <div class="friend-name">${otherUser.username}</div>
                                    <div class="friend-status">Nexus member</div>
                                </div>
                            </div>
                            <div class="friend-actions">
                                <button type="button" class="btn-add"
                                    data-user-id="${otherUser.id}"
                                    onclick="sendFriendRequestData(this)">
                                    <i class="fas fa-plus"></i> Connect
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <script>
    function handleFriendRequestNoCSRF(requestId, action) {
        const btn = event.target.closest('button');
        const orig = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        btn.disabled = true;
        const url = '/FacebookCopy/friends/request/' + action + '/' + requestId;
        const formData = new FormData();
        const csrfMeta = document.querySelector('meta[name="_csrf"]');
        if (csrfMeta?.getAttribute('content')) formData.append('_csrf', csrfMeta.getAttribute('content'));
        fetch(url, { method: 'POST', body: formData })
            .then(r => { if (r.redirected || r.ok) window.location.reload(); else throw new Error(r.status); })
            .catch(e => { btn.disabled = false; btn.innerHTML = orig; alert('Error: ' + e.message); });
    }

    function sendFriendRequestData(buttonElement) {
        const receiverId = buttonElement.getAttribute('data-user-id');
        const orig = buttonElement.innerHTML;
        buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        buttonElement.disabled = true;
        const formData = new FormData();
        formData.append('receiverId', receiverId);
        const csrfMeta = document.querySelector('meta[name="_csrf"]');
        if (csrfMeta?.getAttribute('content')) formData.append('_csrf', csrfMeta.getAttribute('content'));
        fetch('/FacebookCopy/friends/request/send', { method: 'POST', body: formData })
            .then(r => {
                if (r.redirected || r.ok) {
                    buttonElement.innerHTML = '<i class="fas fa-check"></i> Sent';
                    buttonElement.style.color = 'var(--green)';
                    setTimeout(() => window.location.reload(), 800);
                } else throw new Error(r.status);
            })
            .catch(e => { buttonElement.disabled = false; buttonElement.innerHTML = orig; alert('Failed: ' + e.message); });
    }
    </script>
</body>
</html>
