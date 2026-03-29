<%@ include file="layout.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="Feed" />
<link href="${pageContext.request.contextPath}/css/posts.css" rel="stylesheet" type="text/css">
<style>
    .feed-header {
        max-width: 680px;
        margin: 24px auto 20px;
        padding: 0 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .feed-title { color: var(--text); font-size: 1.5rem; font-weight: 700; margin: 0; }
    .feed-subtitle { color: var(--text-2); font-size: 0.9rem; margin: 2px 0 0; }
    .create-post-btn {
        background: linear-gradient(135deg, var(--primary), var(--primary-h));
        border: none; border-radius: 10px; padding: 10px 20px;
        font-weight: 600; color: white; text-decoration: none;
        display: inline-flex; align-items: center; gap: 6px;
        font-size: 0.9rem; transition: all 0.2s; white-space: nowrap;
    }
    .create-post-btn:hover { opacity: 0.9; color: white; transform: translateY(-1px); }
    .posts-main { max-width: 680px; margin: 0 auto; padding: 0 16px 40px; }
    .post-card {
        background: var(--bg-card); border: 1px solid var(--border);
        border-radius: 16px; margin-bottom: 16px; overflow: hidden;
        transition: border-color 0.2s, transform 0.2s;
    }
    .post-card:hover { border-color: var(--primary); transform: translateY(-2px); }
    .post-card .card-body { padding: 20px; }
    .post-meta { display: flex; align-items: center; gap: 8px; margin-bottom: 14px; flex-wrap: wrap; }
    .user-badge {
        display: inline-flex; align-items: center; gap: 6px;
        background: var(--bg-surface); border-radius: 20px; padding: 5px 12px;
        font-size: 0.85rem; font-weight: 600; color: var(--text);
    }
    .user-badge i { color: var(--primary); }
    .time-badge { color: var(--text-3); font-size: 0.8rem; }
    .owner-badge {
        margin-left: auto; background: rgba(124,58,237,0.15);
        color: var(--primary-h); font-size: 0.75rem; font-weight: 600;
        padding: 3px 10px; border-radius: 20px;
        display: inline-flex; align-items: center; gap: 4px;
    }
    .post-content { color: var(--text); font-size: 1rem; line-height: 1.65; margin-bottom: 16px; }
    .post-stats {
        display: flex; gap: 16px; padding: 10px 0;
        border-top: 1px solid var(--border); border-bottom: 1px solid var(--border);
        margin-bottom: 4px; color: var(--text-3); font-size: 0.85rem;
    }
    .post-stat { display: flex; align-items: center; gap: 5px; }
    .post-actions { display: flex; gap: 4px; padding-top: 6px; }
    .post-action {
        flex: 1; display: flex; align-items: center; justify-content: center; gap: 6px;
        padding: 9px 8px; background: none; border: none; border-radius: 8px;
        color: var(--text-2); font-weight: 600; font-size: 0.875rem;
        cursor: pointer; transition: all 0.2s;
    }
    .post-action:hover { background: var(--hover); color: var(--primary-h); }
    .post-action.liked { color: var(--primary-h); }
    .read-more-btn {
        background: none; border: none; color: var(--primary-h);
        font-weight: 600; cursor: pointer; padding: 4px 0;
        font-size: 0.875rem; margin-top: 6px; display: block;
    }
    .read-more-btn:hover { text-decoration: underline; }
    .empty-state {
        text-align: center; padding: 64px 24px;
        background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px;
    }
    .empty-icon { font-size: 3.5rem; color: var(--border); margin-bottom: 16px; }
    .empty-title { color: var(--text); font-size: 1.25rem; font-weight: 700; margin-bottom: 8px; }
    .empty-subtitle { color: var(--text-2); font-size: 0.9375rem; margin-bottom: 24px; }
    .posts-counter {
        text-align: center; margin-top: 8px; padding: 16px;
        color: var(--text-3); font-size: 0.875rem;
        display: flex; align-items: center; justify-content: center; gap: 8px;
    }
    .posts-counter::before, .posts-counter::after {
        content: ''; flex: 1; height: 1px; background: var(--border); max-width: 80px;
    }
</style>
</head>
<body>

    <br><br>

    <div class="feed-header">
        <div>
            <h1 class="feed-title">Your Feed</h1>
            <p class="feed-subtitle">See what's happening in your network</p>
        </div>
        <a href="<c:url value='/posts/new' />" class="create-post-btn">
            <i class="fas fa-plus"></i> New Post
        </a>
    </div>

    <div class="posts-main">
        <c:if test="${empty posts}">
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-newspaper"></i></div>
                <h3 class="empty-title">Nothing here yet</h3>
                <p class="empty-subtitle">Connect with people and their posts will appear here.</p>
                <a href="<c:url value='/posts/new' />" class="create-post-btn">
                    <i class="fas fa-edit"></i> Create Your First Post
                </a>
            </div>
        </c:if>

        <c:if test="${not empty posts}">
            <div class="posts-grid">
                <c:forEach items="${posts}" var="post" varStatus="status">
                    <div class="post-card">
                        <div class="card-body">
                            <div class="post-meta">
                                <span class="user-badge">
                                    <i class="fas fa-circle-user"></i>
                                    ${post.idUser.username}
                                </span>
                                <span class="time-badge">${post.createdAt}</span>
                                <c:if test="${post.idUser.id == user.id}">
                                    <span class="owner-badge"><i class="fas fa-check"></i> You</span>
                                </c:if>
                            </div>
                            <div class="post-content">${post.content}</div>
                            <div class="post-actions">
                                <button class="post-action">
                                    <i class="far fa-heart"></i> Like
                                </button>
                                <button class="post-action">
                                    <i class="far fa-comment"></i> Comment
                                </button>
                                <button class="post-action">
                                    <i class="fas fa-share-nodes"></i> Share
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="posts-counter">
                <i class="fas fa-check-circle" style="color:var(--green)"></i>
                You're all caught up &mdash; ${posts.size()} post${posts.size() != 1 ? 's' : ''}
            </div>
        </c:if>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.post-content').forEach(content => {
                const text = content.textContent || content.innerText;
                if (text.length > 250) {
                    const original = content.innerHTML;
                    const truncated = text.substring(0, 250) + '...';
                    content.innerHTML = truncated;
                    const btn = document.createElement('button');
                    btn.className = 'read-more-btn';
                    btn.textContent = 'See more';
                    btn.addEventListener('click', function() {
                        if (content.classList.contains('expanded')) {
                            content.innerHTML = truncated;
                            content.appendChild(btn);
                            btn.textContent = 'See more';
                            content.classList.remove('expanded');
                        } else {
                            content.innerHTML = original;
                            content.appendChild(btn);
                            btn.textContent = 'See less';
                            content.classList.add('expanded');
                        }
                    });
                    content.appendChild(btn);
                }
            });

            document.querySelectorAll('.post-action').forEach(btn => {
                if (btn.innerHTML.includes('Like')) {
                    btn.addEventListener('click', function() {
                        const icon = this.querySelector('i');
                        if (icon.classList.contains('far')) {
                            icon.className = 'fas fa-heart';
                            this.classList.add('liked');
                        } else {
                            icon.className = 'far fa-heart';
                            this.classList.remove('liked');
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>
