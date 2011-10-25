function collect_record_ids() {
  var res = [];
  $$('#feedbacks .record').each(function (record) {
    if (record.id.startsWith('record')) {
      res.push(record.id.substr(6));
    }
  });
  return 'record_ids='+res.toString();
}