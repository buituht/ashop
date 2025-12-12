<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header bg-info text-white">SMTP Test</div>
                <div class="card-body">
                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-danger">${requestScope.error}</div>
                    </c:if>
                    <c:if test="${not empty requestScope.success}">
                        <div class="alert alert-success">${requestScope.success}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/smtp-test" method="post">
                        <div class="mb-3">
                            <label class="form-label">To (email)</label>
                            <input class="form-control" type="email" name="to" value="${param.to}" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Subject</label>
                            <input class="form-control" name="subject" value="${param.subject}" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Body</label>
                            <textarea class="form-control" name="body">${param.body}</textarea>
                        </div>
                        <div>
                            <button class="btn btn-primary" type="submit">Send Test Email</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
