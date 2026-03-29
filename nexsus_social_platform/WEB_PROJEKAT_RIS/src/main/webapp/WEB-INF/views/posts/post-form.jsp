<%@ include file="../layout.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="${post.id == null ? 'New Post' : 'Edit Post'}" />
<link href="${pageContext.request.contextPath}/css/post-form.css" rel="stylesheet" type="text/css">
<style>
    .composer-wrap { max-width: 680px; margin: 28px auto; padding: 0 16px 40px; }
    .composer-card {
        background: var(--bg-card); border: 1px solid var(--border);
        border-radius: 20px; overflow: hidden;
    }
    .composer-top {
        padding: 20px 20px 0; border-bottom: 1px solid var(--border); padding-bottom: 16px;
        display: flex; align-items: center; gap: 14px;
    }
    .user-avatar {
        width: 44px; height: 44px; border-radius: 50%; flex-shrink: 0;
        background: linear-gradient(135deg, var(--primary), var(--accent));
        display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: 1.1rem; color: white; text-transform: uppercase;
    }
    .composer-heading { color: var(--text); font-size: 1.2rem; font-weight: 700; margin: 0; }
    .composer-heading span { color: var(--primary-h); }
    .composer-body { padding: 20px; }
    .composer-input, .composer-content {
        width: 100%; background: var(--bg-surface); border: 1px solid var(--border);
        border-radius: 10px; color: var(--text); font-size: 1rem; font-family: inherit;
        padding: 12px 14px; resize: none; transition: border-color 0.2s;
        outline: none; display: block; box-sizing: border-box;
    }
    .composer-input:focus, .composer-content:focus { border-color: var(--primary); }
    .composer-input::placeholder, .composer-content::placeholder { color: var(--text-3); }
    .composer-input { margin-bottom: 12px; }
    .composer-content { min-height: 120px; }
    .char-count {
        text-align: right; font-size: 0.8rem; color: var(--text-3); margin-top: 4px;
    }
    .char-count.warning { color: var(--danger); }
    .composer-footer {
        display: flex; justify-content: space-between; align-items: center;
        padding: 14px 20px; border-top: 1px solid var(--border);
        background: var(--bg-surface);
    }
    .flair-btns { display: flex; gap: 6px; }
    .flair-btn {
        width: 36px; height: 36px; border-radius: 50%; border: none;
        background: var(--bg-elevated, #21213a); color: var(--text-2);
        display: flex; align-items: center; justify-content: center;
        cursor: pointer; transition: all 0.2s; font-size: 1rem;
    }
    .flair-btn:hover { background: var(--hover); color: var(--primary-h); }
    .footer-actions { display: flex; gap: 10px; align-items: center; }
    .cancel-btn {
        padding: 9px 18px; border-radius: 10px; text-decoration: none;
        color: var(--text-2); font-weight: 600; font-size: 0.9rem;
        border: 1px solid var(--border); transition: all 0.2s;
    }
    .cancel-btn:hover { border-color: var(--text-3); color: var(--text); }
    .post-btn {
        padding: 9px 22px; border-radius: 10px; border: none;
        background: linear-gradient(135deg, var(--primary), var(--primary-h));
        color: white; font-weight: 600; font-size: 0.9rem; cursor: pointer;
        transition: all 0.2s; display: inline-flex; align-items: center; gap: 6px;
    }
    .post-btn:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
    .post-btn:disabled { opacity: 0.5; cursor: not-allowed; }
</style>
</head>
<body>
    <div class="composer-wrap">
        <div class="composer-card">
            <div class="composer-top">
                <div class="user-avatar">${user.username.charAt(0)}</div>
                <h1 class="composer-heading">
                    <c:choose>
                        <c:when test="${post.id == null}">Create a <span>new post</span></c:when>
                        <c:otherwise>Edit your <span>post</span></c:otherwise>
                    </c:choose>
                </h1>
            </div>
            <div class="composer-body">
                <input type="hidden" id="postId" value="${post.id}">
                <input type="text" id="title" class="composer-input"
                       placeholder="Title â€” what's this about?"
                       value="${post.title}" maxlength="200">
                <textarea id="content" class="composer-content"
                          placeholder="Share your thoughts with the Nexus community..."
                          maxlength="5000">${post.content}</textarea>
                <div class="char-count" id="charCount">
                    ${post.content != null ? post.content.length() : 0}/5000
                </div>
            </div>
            <div class="composer-footer">
                <div class="flair-btns">
                    <button class="flair-btn" title="Add Photo"><i class="fas fa-image"></i></button>
                    <button class="flair-btn" title="Tag People"><i class="fas fa-user-tag"></i></button>
                    <button class="flair-btn" title="Add Feeling"><i class="fas fa-face-smile"></i></button>
                    <button class="flair-btn" title="Add Location"><i class="fas fa-location-dot"></i></button>
                </div>
                <div class="footer-actions">
                    <a href="<c:url value='/posts/my' />" class="cancel-btn">Cancel</a>
                    <button class="post-btn" id="postButton" onclick="savePost()">
                        <i class="fas fa-paper-plane"></i>
                        <c:choose>
                            <c:when test="${post.id == null}">Publish</c:when>
                            <c:otherwise>Save Changes</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const titleInput = document.getElementById('title');
        const contentInput = document.getElementById('content');
        const charCount = document.getElementById('charCount');
        const postButton = document.getElementById('postButton');

        function updateUI() {
            const len = contentInput.value.length;
            charCount.textContent = len + '/5000';
            charCount.className = 'char-count' + (len > 4800 ? ' warning' : '');
            postButton.disabled = !(titleInput.value.trim() && contentInput.value.trim());
        }

        titleInput.addEventListener('input', updateUI);
        contentInput.addEventListener('input', function() {
            updateUI();
            this.style.height = 'auto';
            this.style.height = this.scrollHeight + 'px';
        });
        updateUI();

        function savePost() {
            const title = titleInput.value.trim();
            const content = contentInput.value.trim();
            if (!title || !content) { alert('Please add both a title and content.'); return; }

            const formData = new FormData();
            formData.append('id', document.getElementById('postId').value);
            formData.append('title', title);
            formData.append('content', content);

            const orig = postButton.innerHTML;
            postButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
            postButton.disabled = true;

            fetch('<c:url value="/posts/save" />', { method: 'POST', body: formData })
                .then(response => { if (response.redirected) window.location.href = response.url; })
                .catch(() => { alert('Error saving post'); postButton.innerHTML = orig; postButton.disabled = false; });
        }
    </script>
</body>
</html>
