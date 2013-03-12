$(document).ready(function(){
  $('#admin_user a.op').click(function() {
    var o = {'id':'', 'op':''};
    o.id = $(this).attr('data-id')
    o.op = $(this).attr('data-op');
    $.post('/admin/user_op', o, function(data){
      if (data.ret == 'succ') alert('操作成功');
      else alert('操作失败');
      window.location.reload();
    }, 'json');
  });
});
