<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@include file="/WEB-INF/jsp/include/head.jspf" %>
<link href="/resource/bootstrap/plugins/summernote/summernote-bs4.min.css" rel="stylesheet"/>

<div class="content-wrapper">
  <div class="col-md-12" style="text-align:right; margin-top:15px; margin-bottom:15px; background-color:white;">
    <h1 style="text-align:left; background-color:white;">게시글 등록</h1>
    <button class="btn btn-sidebar" style="background-color: #D7D7D7; width: 100px;"><a href="/article/list">목록</a></button>
  </div>
  <div class="col-md-12" style="text-align:center;">
    <table class="table w-full">
      <thead>
        <tr>
          <th>제목</th>
          <td style="background-color:white;"><input type="text" placeholder="제목을 입력해 주세요" style="width:500px; border:none;" id="article_title"></td>
        </tr>
        <tr>
          <th>작성자</th>
          <td style="background-color:white;">${loginUser.member_id}</td>
        </tr>
        <tr>
          <th>등록일</th>
          <td id="currentDate" style="background-color:white;"></td>
        </tr>
        
      </thead>
    </table>
    <div class="col-md-5" style="text-align:start; margin-left:250px;">
      <label for="fileUpload" class="file-label" style="margin-left:15px;">파일 선택</label>
      <input type="file" id="fileUpload" style="width:300px;" name="article_attach">
    </div>
    <div class="contentbox">
      <textarea class="content summernote" name="content" id="content"></textarea>
      <span style="float: right;">
       <button type="button" onclick="postArticle();" class="btn btn-sidebar" style="background-color: #5865F2; width: 100px;">등록</button>
        <button onclick="history_back();" class="btn btn-sidebar" style="background-color: #DC3545; width: 100px;">취소</button>
      </span>
    </div>
  </div>
</div>

<%@include file="/WEB-INF/jsp/include/foot.jspf" %>

<script>
  $(document).ready(function() {
    $('.summernote').summernote({
      height: 500
    });
  });
  var today = new Date();
  var formattedDate = today.toISOString().split('T')[0];
  document.getElementById("currentDate").textContent = formattedDate;
  function postArticle() {
    var formData = new FormData();
    formData.append('article_title', document.getElementById('article_title').value);
    formData.append('article_register', '${loginUser.member_id}');
    formData.append('article_body', document.getElementById('content').value);
    if ('article_attach' === null) {
         formData.append('article_attach', document.getElementById('fileUpload').value);
       } else {
        var fileUpload = document.getElementById('fileUpload');
         for (var i = 0; i < fileUpload.files.length; i++) {
           var file = fileUpload.files[i];
           var fileDownloadName = generateDownloadName(file.name);
           formData.append('article_attach', file, fileDownloadName);
         }
       }
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/article/write', true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          console.log(xhr.responseText);
          window.location.href = '/article/list'; // 리다이렉트 수행
        } else {
          window.location.href = '/article/list'; // 에러 발생 시에도 리다이렉트 수행
        }
      }
    };
    xhr.send(formData);
  }
  function generateDownloadName(originalName) {
    var timestamp = new Date().getTime(); // 타임스탬프를 파일 이름에 추가
    var extension = originalName.split('.').pop(); // 파일 확장자 추출
    return timestamp + '.' + extension;
  }
  var uploadedFiles = [];
  document.getElementById('fileUpload').addEventListener('change', function(event) {
    var files = event.target.files;
    for (var i = 0; i < files.length; i++) {
      var file = files[i];
      uploadedFiles.push(file);
      var fileInfo = document.createElement('div');
      fileInfo.textContent = file.name;
      fileInfo.style.backgroundColor = 'white';
      fileInfo.style.border = '1px solid black';
      fileInfo.style.padding = '5px';
      var deleteButton = document.createElement('button');
      deleteButton.textContent = 'X';
      deleteButton.dataset.index = i;
      deleteButton.classList.add('btn', 'btn-danger');
      deleteButton.style.marginLeft = '10px';
      deleteButton.style.marginTop = '10px';
      deleteButton.addEventListener('click', function(event) {
        var index = event.target.dataset.index;
        uploadedFiles.splice(index, 1);
        event.target.parentElement.remove();
      });
      fileInfo.appendChild(deleteButton);
      event.target.parentElement.appendChild(fileInfo);
    }
  });
  function updateImportance(value) {
    document.getElementById('article_important').value = value;
  }
</script>