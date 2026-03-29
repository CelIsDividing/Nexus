<%@ include file="../layout.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="My Posts" />
<link href="${pageContext.request.contextPath}/css/my-posts.css" rel="stylesheet" type="text/css">
<style>
    .profile-main { max-width: 680px; margin: 0 auto; padding: 0 16px 40px; }
    .profile-header-card {
        background: var(--bg-card); border: 1px solid var(--border);
        border-radius: 16px; padding: 28px; margin: 24px 0 20px;
        display: flex; align-items: center; gap: 20px; flex-wrap: wrap;
    }
    .avatar-lg {
        width: 72px; height: 72px; border-radius: 50%; flex-shrink: 0;
        background: linear-gradient(135deg, var(--primary), var(--accent));
        display: flex; align-items: center; justify-content: center;
        font-size: 2rem; color: white; font-weight: 700;
    }
    .profile-info { flex: 1; }
    .profile-name { color: var(--text); font-size: 1.4rem; font-weight: 700; margin: 0 0 4px; }
    .profile-handle { color: var(--text-3); font-size: 0.9rem; margin: 0; }
    .profile-stats { display: flex; gap: 24px; flex-wrap: wrap; margin-left: auto; }
    .stat-item { text-align: center; }
    .stat-number { font-size: 1.5rem; font-weight: 700; color: var(--primary-h); display: block; }
    .stat-label { font-size: 0.8rem; color: var(--text-3); }
    .section-actions {
        display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;
    }
    .section-title { color: var(--text); font-size: 1.1rem; font-weight: 700; margin: 0; }
    .create-post-btn {
        background: linear-gradient(135deg, var(--primary), var(--primary-h));
        border: none; border-radius: 10px; padding: 9px 18px;
        font-weight: 600; color: white; text-decoration: none;
        display: inline-flex; align-items: center; gap: 6px;
        font-size: 0.875rem; transition: all 0.2s;
    }
    .create-post-btn:hover { opacity: 0.9; color: white; transform: translateY(-1px); }
    .post-card {
        background: var(--bg-card); border: 1px solid var(--border);
        border-radius: 16px; margin-bottom: 16px; overflow: hidden;
        transition: border-color 0.2s, transform 0.2s;
    }
    .post-card:hover { border-color: var(--primary); transform: translateY(-2px); }
    .post-card .card-body { padding: 20px; }
    .user-meta { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
    .user-badge {
        background: var(--bg-surface); border-radius: 20px; padding: 5px 12px;
        font-size: 0.85rem; font-weight: 600; color: var(--text);
        display: inline-flex; align-items: center; gap: 6px;
    }
    .user-badge i { color: var(--primary); }
    .time-badge { color: var(--text-3); font-size: 0.8rem; }
    .post-content { color: var(--text); font-size: 1rem; line-height: 1.65; margin-bottom: 16px; }
    .post-actions { display: flex; gap: 10px; padding-top: 14px; border-top: 1px solid var(--border); }
    .btn-edit {
        background: linear-gradient(135deg, var(--primary), var(--primary-h));
        border: none; border-radius: 8px; padding: 8px 16px;
        color: white; font-weight: 600; text-decoration: none;
        display: inline-flex; align-items: center; gap: 6px;
        font-size: 0.875rem; flex: 1; justify-content: center; transition: all 0.2s;
    }
    .btn-edit:hover { opacity: 0.9; color: white; }
    .btn-delete {
        background: rgba(239,68,68,0.12); border: 1px solid rgba(239,68,68,0.3);
        border-radius: 8px; padding: 8px 16px; color: var(--danger); font-weight: 600;
        display: inline-flex; align-items: center; gap: 6px;
        font-size: 0.875rem; flex: 1; justify-content: center; cursor: pointer; transition: all 0.2s;
    }
    .btn-delete:hover { background: rgba(239,68,68,0.2); }
    .read-more-btn {
        background: none; border: none; color: var(--primary-h); font-weight: 600;
        cursor: pointer; padding: 4px 0; font-size: 0.875rem; margin-top: 6px; display: block;
    }
    .read-more-btn:hover { text-decoration: underline; }
    .empty-state {
        text-align: center; padding: 64px 24px;
        background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px;
    }
    .empty-icon { font-size: 3.5rem; color: var(--border); margin-bottom: 16px; }
    .empty-title { color: var(--text); font-size: 1.25rem; font-weight: 700; margin-bottom: 8px; }
    .empty-subtitle { color: var(--text-2); font-size: 0.9375rem; margin-bottom: 24px; }
</style>
</head>
<body>
    <div class="profile-main">
        <div class="profile-header-card">
            <div class="avatar-lg">${user.username.substring(0,1).toUpperCase()}</div>
            <div class="profile-info">
                <h1 class="profile-name">${user.username}</h1>
                <p class="profile-handle">@${user.username}</p>
            </div>
            <div class="profile-stats">
                <div class="stat-item">
                    <span class="stat-number">${posts.size()}</span>
                    <span class="stat-label">Posts</span>
                </div>
            </div>
        </div>

        <div class="section-actions">
            <h2 class="section-title">My Posts</h2>
            <a href="<c:url value='/posts/new' />" class="create-post-btn">
                <i class="fas fa-plus"></i> New Post
            </a>
        </div>

        <div class="my-posts-container">
            <c:if test="${empty posts}">
                <div class="empty-state">
                    <div class="empty-icon"><i class="fas fa-feather-pointed"></i></div>
                    <h3 class="empty-title">No posts yet</h3>
                    <p class="empty-subtitle">Share your thoughts with the Nexus community.</p>
                    <a href="<c:url value='/posts/new' />" class="create-post-btn">
                        <i class="fas fa-plus"></i> Create Your First Post
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty posts}">
                <c:forEach items="${posts}" var="post">
                    <div class="post-card">
                        <div class="card-body">
                            <div class="user-meta">
                                <span class="user-badge">
                                    <i class="fas fa-circle-user"></i>
                                    ${user.username}
                                </span>
                                <span class="time-badge">${post.createdAt}</span>
                            </div>
                            <div class="post-content">${post.content}</div>
                            <div class="post-actions">
                                <a href="<c:url value='/posts/edit/${post.id}' />" class="btn-edit">
                                    <i class="fas fa-pen"></i> Edit
                                </a>
                                <button onclick="confirmDelete(${post.id})" class="btn-delete">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
        </div>
    </div>

    <script>
        function confirmDelete(postId) {
            if (confirm("Are you sure you want to delete this post?")) {
                window.location.href = '<c:url value="/posts/delete/"/>' + postId;
            }
        }
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
        });
    </script>
</body>
</html>
