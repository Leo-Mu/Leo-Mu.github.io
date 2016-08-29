{% if theme.tencent_analytics %}
  <script type="text/javascript">
    (function() {
      var hm = document.createElement("script");
      hm.src = "//tajs.qq.com/stats?sId={{ theme.tencent_analytics }}";
      var s = document.getElementsByTagName("script")[0];
      s.parentNode.insertBefore(hm, s);
    })();
  </script>
{% endif %}
<script type="text/javascript" src="http://tajs.qq.com/stats?sId=58158000" charset="UTF-8"></script>
