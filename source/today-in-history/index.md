---
title: 历史上的今天
comments: false
date: 2023-12-27 10:10:10
---

<div id='content'>
</div>

<script>
  const content = document.getElementById('content')
  let today = new Date();
  let path = ''

  if (today.getMonth() < 9) {
    path += '0'
  }
  path += `${(today.getMonth() + 1)}`

  if (today.getDate() < 10) {
    path += '0'
  }
  path += `${today.getDate()}`

  fetch(`https://shwst.one/today-in-history-data/${path}.json`)
    .then((response) => response.json())
    .then((data) => {
      content.innerHTML = `今天是${today.getMonth() + 1}月${today.getDate()}日，在历史上的今天，发生了这些事：`
      for (let event of data) {																								
        content.innerHTML += `</br>${event.title}`
      }
    });
</script>
