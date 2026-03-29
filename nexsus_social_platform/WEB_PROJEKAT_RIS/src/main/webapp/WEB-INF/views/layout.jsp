<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<title><c:out value="${pageTitle}" /> — Nexus</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/layout.css" rel="stylesheet" type="text/css">
</head>
<body>
	<!-- Nexus Navigation Bar -->
	<nav class="nexus-navbar">
		<a class="nav-brand" href="<c:url value='/posts' />">
			<i class="fas fa-bolt"></i>
			<span>Nexus</span>
		</a>

		<c:if test="${not empty user}">
			<ul class="nav-menu">
				<li class="nav-item">
					<a href="<c:url value='/posts/new' />" class="nav-create-btn" title="New Post">
						<i class="fas fa-plus"></i>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<c:url value='/admin/users' />">
						<i class="fas fa-shield-halved"></i>
						<span>Admin</span>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<c:url value='/posts' />">
						<i class="fas fa-house"></i>
						<span>Feed</span>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<c:url value='/posts/my' />">
						<i class="fas fa-circle-user"></i>
						<span>Profile</span>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<c:url value='/friends' />">
						<i class="fas fa-users"></i>
						<span>Connect</span>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<c:url value='/messages' />">
						<i class="fas fa-message"></i>
						<span>Messages</span>
					</a>
				</li>
				<li class="nav-item">
					<button type="button" class="logout-btn" data-username="${user.username}">
						<div class="user-avatar">
							<c:set var="firstLetter" value="${user.username.charAt(0)}" />
							${firstLetter}
						</div>
						<span>Logout</span>
					</button>
				</li>
			</ul>
		</c:if>
	</nav>

	<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Active nav link
        const currentPath = window.location.pathname;
        document.querySelectorAll('.nav-link').forEach(link => {
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active');
            }
        });

        // Logout
        document.querySelectorAll('.logout-btn').forEach(button => {
            button.addEventListener('click', function() {
                const username = this.getAttribute('data-username');
                if (confirm('Sign out of Nexus, ' + username + '?')) {
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                    this.disabled = true;
                    performLogout();
                }
            });
        });

        function performLogout() {
            const csrfToken  = document.querySelector('meta[name="_csrf"]').content;
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;
            const formData   = new URLSearchParams();
            formData.append(csrfHeader, csrfToken);

            fetch('<c:url value="/logout" />', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(response => {
                if (response.redirected) {
                    window.location.href = response.url;
                } else if (response.ok) {
                    window.location.href = '<c:url value="/" />';
                } else {
                    throw new Error('Logout failed');
                }
            })
            .catch(error => {
                console.error('Logout error:', error);
                alert('Logout failed. Please try again.');
                const btn = document.querySelector('.logout-btn');
                if (btn) {
                    const u = btn.getAttribute('data-username');
                    btn.innerHTML = '<div class="user-avatar">' + u.charAt(0) + '</div><span>Logout</span>';
                    btn.disabled = false;
                }
            });
        }
    });
</script>
</body>
</html>
