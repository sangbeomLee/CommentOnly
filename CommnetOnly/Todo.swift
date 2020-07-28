/*
 1. apikey = https://www.googleapis.com/youtube/v3/videos?regionCode=kr&chart=mostpopular&maxResults=10&part=snippet&key=AIzaSyB9KjHO7YpeiyC4hk9V8dJu9x1DrIf9SSc
 인기 동영상 + 10개 가져오고 + key
 
 https://www.googleapis.com/youtube/v3/commentThreads?key=AIzaSyB9KjHO7YpeiyC4hk9V8dJu9x1DrIf9SSc&part=snippet&videoId=v5xdfGU5-GQ&maxResults=100&order=relevance
 
 의문점
 - networkManager를 공유하다보니 Protocol에서 문제있음
 
 해야 하는 것
 - image가 하나 있고 그 밑에 댓글들을 나타내야 하는데 어떻게 해야할 지 생각해보기
 - 누르면 댓글 전체 보이게 하기.
 - 중복이 너무많다 중복 제거하기 -> generic networking을 해보자..
 - 상수값 처리하기
 - 이미지 불러오기.
 - 정렬하기
 - 내부<\b> 이런 것들 처리
 
 통해 얻은 것
 - api 문서를 읽어보며 이것저것 테스트 하고 원하는 값을 가져올 수 있다.
 
 
 
 
 
 
 */
