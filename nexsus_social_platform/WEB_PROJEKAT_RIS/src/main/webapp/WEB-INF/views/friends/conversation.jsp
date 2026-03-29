<%@ include file="../layout.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="Chat with ${friend.username}" />
<link href="<c:url value='/css/chat.css' />" rel="stylesheet">
<style>
    .chat-page { max-width: 960px; margin: 28px auto; padding: 0 16px 40px; }
    .chat-layout { display: grid; grid-template-columns: 260px 1fr; gap: 20px; height: calc(100vh - 140px); min-height: 500px; }
    @media (max-width: 700px) { .chat-layout { grid-template-columns: 1fr; height: auto; } }
    .chat-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; display: flex; flex-direction: column; }
    .card-header { padding: 14px 16px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
    .card-header h5 { color: var(--text); font-size: 0.95rem; font-weight: 700; margin: 0; }
    .card-header i { color: var(--primary-h); }
    .friends-list { flex: 1; overflow-y: auto; }
    .friend-item { border-bottom: 1px solid var(--border); }
    .friend-item:last-child { border-bottom: none; }
    .friend-link { display: flex; align-items: center; gap: 10px; padding: 10px 14px; text-decoration: none; transition: background 0.15s; }
    .friend-link:hover, .friend-link.active { background: var(--hover); }
    .friend-link.active { border-left: 3px solid var(--primary); }
    .friend-avatar {
        width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0;
        background: linear-gradient(135deg, var(--primary), var(--accent));
        display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: 1rem; color: white; text-transform: uppercase;
    }
    .friend-info { flex: 1; min-width: 0; }
    .friend-name { color: var(--text); font-weight: 600; font-size: 0.9rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .last-message { color: var(--text-3); font-size: 0.78rem; margin-top: 1px; }
    .online-indicator { width: 9px; height: 9px; border-radius: 50%; background: var(--green); flex-shrink: 0; }
    .chat-area { display: flex; flex-direction: column; flex: 1; overflow: hidden; }
    .messages-container { flex: 1; overflow-y: auto; padding: 16px; display: flex; flex-direction: column; gap: 8px; }
    .message-bubble { max-width: 72%; }
    .message-sent { align-self: flex-end; }
    .message-received { align-self: flex-start; }
    .message-sender { color: var(--text-3); font-size: 0.78rem; font-weight: 600; margin-bottom: 3px; padding-left: 4px; }
    .message-content {
        padding: 10px 14px; border-radius: 18px; font-size: 0.9rem; line-height: 1.5; word-break: break-word;
    }
    .message-sent .message-content { background: var(--primary); color: white; border-bottom-right-radius: 4px; }
    .message-received .message-content { background: var(--bg-surface); color: var(--text); border-bottom-left-radius: 4px; }
    .message-time { font-size: 0.73rem; color: var(--text-3); margin-top: 4px; padding: 0 4px; }
    .message-sent .message-time { text-align: right; }
    .message-status { margin-left: 4px; color: var(--accent); }
    .message-input-area { padding: 12px 16px; border-top: 1px solid var(--border); flex-shrink: 0; background: var(--bg-surface); }
    .input-group { display: flex; gap: 10px; align-items: center; }
    .message-input {
        flex: 1; background: var(--bg-elevated, #21213a); border: 1px solid var(--border);
        border-radius: 24px; padding: 10px 18px; color: var(--text); font-size: 0.95rem;
        outline: none; font-family: inherit; transition: border-color 0.2s;
    }
    .message-input:focus { border-color: var(--primary); }
    .message-input::placeholder { color: var(--text-3); }
    .send-button {
        background: linear-gradient(135deg, var(--primary), var(--primary-h));
        border: none; border-radius: 50%; width: 42px; height: 42px; flex-shrink: 0;
        color: white; cursor: pointer; display: flex; align-items: center; justify-content: center;
        font-size: 1rem; transition: all 0.2s;
    }
    .send-button:hover { opacity: 0.9; transform: scale(1.05); }
    .send-button:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }
    .empty-chat { text-align: center; margin: auto; padding: 32px; }
    .empty-chat-icon { font-size: 3rem; color: var(--border); margin-bottom: 12px; }
    .empty-chat-title { color: var(--text-2); font-size: 1.1rem; font-weight: 700; margin-bottom: 6px; }
    .empty-chat-subtitle { color: var(--text-3); font-size: 0.875rem; }
</style>
</head>
<body>
    <div class="chat-page">
        <div class="chat-layout">
            <div class="chat-card">
                <div class="card-header">
                    <i class="fas fa-users"></i>
                    <h5>Friends</h5>
                </div>
                <div class="friends-list">
                    <c:forEach items="${friends}" var="f">
                        <div class="friend-item">
                            <a href="<c:url value='/messages/conversation/${f.id}' />"
                               class="friend-link ${f.id == friend.id ? 'active' : ''}">
                                <div class="friend-avatar">${f.username.charAt(0)}</div>
                                <div class="friend-info">
                                    <div class="friend-name">${f.username}</div>
                                    <c:if test="${f.id == friend.id}">
                                        <div class="last-message">Active now</div>
                                    </c:if>
                                </div>
                                <c:if test="${f.id == friend.id}">
                                    <div class="online-indicator"></div>
                                </c:if>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="chat-card">
                <div class="card-header">
                    <div class="friend-avatar" style="width:30px;height:30px;font-size:0.85rem">${friend.username.charAt(0)}</div>
                    <h5>${friend.username}</h5>
                    <div class="online-indicator" style="margin-left:auto"></div>
                </div>
                <div class="chat-area">
                    <div id="messageContainer" class="messages-container">
                        <c:forEach items="${conversation}" var="message">
                            <div class="message-bubble ${message.idUser1.id == user.id ? 'message-sent' : 'message-received'}">
                                <c:if test="${message.idUser1.id != user.id}">
                                    <div class="message-sender">${message.idUser1.username}</div>
                                </c:if>
                                <div class="message-content">${message.content}</div>
                                <div class="message-time">
                                    ${message.sentAt}
                                    <c:if test="${message.idUser1.id == user.id}">
                                        <span class="message-status">&#10003;&#10003;</span>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty conversation}">
                            <div class="empty-chat">
                                <div class="empty-chat-icon"><i class="fas fa-comment-dots"></i></div>
                                <h3 class="empty-chat-title">No messages yet</h3>
                                <p class="empty-chat-subtitle">Say hi to ${friend.username}!</p>
                            </div>
                        </c:if>
                    </div>
                    <div class="message-input-area">
                        <div class="input-group">
                            <input type="text" id="messageInput" class="message-input"
                                   placeholder="Message ${friend.username}..." required>
                            <button type="button" id="sendButton" class="send-button" aria-label="Send">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    function sendMessage() {
        const messageInput = document.getElementById('messageInput');
        const sendButton = document.getElementById('sendButton');
        const content = messageInput.value.trim();
        if (!content) { messageInput.focus(); return; }

        const orig = sendButton.innerHTML;
        messageInput.disabled = true;
        sendButton.disabled = true;
        sendButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

        const formData = new FormData();
        formData.append('receiverId', ${friend.id});
        formData.append('content', content);
        const csrf = document.querySelector('meta[name="_csrf"]');
        if (csrf) formData.append('_csrf', csrf.getAttribute('content'));

        fetch('<c:url value="/messages/send" />', { method: 'POST', body: formData })
            .then(r => { if (r.redirected || r.ok) window.location.reload(); else throw new Error(r.status); })
            .catch(e => { alert('Failed to send: ' + e.message); })
            .finally(() => { messageInput.disabled = false; sendButton.disabled = false; sendButton.innerHTML = orig; messageInput.value = ''; messageInput.focus(); });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const mc = document.getElementById('messageContainer');
        if (mc) mc.scrollTop = mc.scrollHeight;
        document.getElementById('sendButton')?.addEventListener('click', sendMessage);
        const mi = document.getElementById('messageInput');
        if (mi) { mi.addEventListener('keypress', e => { if (e.key === 'Enter') sendMessage(); }); mi.focus(); }
    });
    </script>
</body>
</html>
