fixture = (name) ->
  html = window.__html__["test/fixtures/" + name + ".html"]
  $("body").html(html)
