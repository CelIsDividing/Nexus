<%@ include file="../layout.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="Messages" />
<link href="<c:url value='/css/messages.css' />" rel="stylesheet"><style>
    .messages-wrap { max-width: 960px; margin: 28px auto; padding: 0 16px 40px; }
    .page-title { color: var(--text); font-size: 1.5rem; font-weight: 700; margin: 0 0 20px; }
    .messages-layout { display: grid; grid-template-columns: 320px 1fr; gap: 20px; }
    @media (max-width: 700px) { .messages-layout { grid-template-columns: 1fr; } }
    .message-card {
        background: var(--bg-card); border: 1px solid var(--border);
        border-radius: 16px; overflow: hidden;
    }
    .card-header {
        padding: 16px 20px; border-bottom: 1px solid var(--border);
        display: flex; align-items: center; gap: 10px;
    }
    .card-header h5 { color: var(--text); font-size: 1rem; font-weight: 700; margin: 0; }
    .card-header i { color: var(--primary-h); }
    .friends-list { padding: 8px 0; }
    .friend-item { border-bottom: 1px solid var(--border); }
    .friend-item:last-child { border-bottom: none; }
    .friend-link {
        display: flex; align-items: center; gap: 12px;
        padding: 12px 20px; text-decoration: none; transition: background 0.15s;
        position: relative;
    }
    .friend-link:hover { background: var(--hover); }
    .friend-avatar {
        width: 44px; height: 44px; border-radius: 50%; flex-shrink: 0;
        background: linear-gradient(135deg, var(--primary), var(--accent));
        display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: 1.1rem; color: white; text-transform: uppercase;
    }
    .friend-info { flex: 1; min-width: 0; }
    .friend-name { color: var(--text); font-weight: 600; font-size: 0.95rem; }
    .last-message { color: var(--text-3); font-size: 0.8rem; margin-top: 2px; }
    .online-indicator {
        width: 10px; height: 10px; border-radius: 50%;
        background: var(--green); flex-shrink: 0;
    }
    .welcome-state { text-align: center; padding: 48px 24px; }
    .welcome-icon { font-size: 4rem; color: var(--primary); margin-bottom: 16px; opacity: 0.4; }
    .welcome-title { color: var(--text); font-size: 1.3rem; font-weight: 700; margin-bottom: 8px; }
    .welcome-subtitle { color: var(--text-2); font-size: 0.95rem; line-height: 1.6; margin-bottom: 24px; }
    .features-list { display: flex; flex-direction: column; gap: 12px; align-items: flex-start; max-width: 220px; margin: 0 auto; }
    .feature-item { display: flex; align-items: center; gap: 10px; color: var(--text-2); font-size: 0.9rem; }
    .feature-item i { color: var(--primary-h); width: 18px; }
    .btn-primary {
        background: linear-gradient(135deg, var(--primary), var(--primary-h));
        border: none; border-radius: 10px; padding: 10px 20px;
        color: white; font-weight: 600; font-size: 0.9rem;
        text-decoration: none; display: inline-flex; align-items: center; gap: 6px;
        transition: all 0.2s;
    }
    .btn-primary:hover { opacity: 0.9; color: white; }
    .empty-state { text-align: center; padding: 32px 20px; }
    .empty-icon { font-size: 2.5rem; color: var(--border); margin-bottom: 10px; }
    .empty-title { color: var(--text-2); font-size: 0.95rem; font-weight: 600; margin-bottom: 4px; }
    .empty-subtitle { color: var(--text-3); font-size: 0.85rem; margin-bottom: 16px; }
</style>
</head>
<body>
    <div class="messages-wrap">
        <h1 class="page-title"><i class="fas fa-comments" style="color:var(--primary-h);margin-right:10px"></i>Messages</h1>
        <div class="messages-layout">
            <div class="message-card">
                <div class="card-header">
                    <i class="fas fa-users"></i>
                    <h5>Your Friends</h5>
                </div>
                <div class="card-body">
                    <div class="friends-list">
                        <c:forEach items="${friends}" var="friend">
                            <div class="friend-item">
                                <a href="<c:url value='/messages/conversation/${friend.id}' />" class="friend-link">
                                    <div class="friend-avatar">${friend.username.charAt(0)}</div>
                                    <div class="friend-info">
                                        <div class="friend-name">${friend.username}</div>
                                        <div class="last-message">Click to chat</div>
                                    </div>
                                    <div class="online-indicator"></div>
                                </a>
                            </div>
                        </c:forEach>
                        <c:if test="${empty friends}">
                            <div class="empty-state">
                                <div class="empty-icon"><i class="fas fa-user-group"></i></div>
                                <p class="empty-title">No friends yet</p>
                                <p class="empty-subtitle">Add friends to start messaging</p>
                                <a href="<c:url value='/friends' />" class="btn-primary">
                                    <i class="fas fa-user-plus"></i> Find Friends
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="message-card">
                <div class="card-body">
                    <div class="welcome-state">
                        <div class="welcome-icon"><i class="fas fa-comments"></i></div>
                        <h3 class="welcome-title">Your Messages</h3>
                        <p class="welcome-subtitle">Select a friend to start a conversation.<br>Stay connected with your Nexus network.</p>
                        <div class="features-list">
                            <div class="feature-item"><i class="fas fa-lock"></i><span>End-to-end secure</span></div>
                            <div class="feature-item"><i class="fas fa-bolt"></i><span>Instant delivery</span></div>
                            <div class="feature-item"><i class="fas fa-user-shield"></i><span>Friends only</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html><style>
