$(document).ready(function(){
  $('#admin_setting a.op').click(function() {
    if (confirm('确定吗?')) {
      var o = {'id':'', 'op':''};
      o.id = $(this).attr('data-id')
      o.op = $(this).attr('data-op');
      $.post('/admin/setting_op', o, function(data){
        if (data.ret == 'succ') alert('操作成功');
        else alert('操作失败');
        window.location.reload();
      }, 'json');
    }
  });
});
