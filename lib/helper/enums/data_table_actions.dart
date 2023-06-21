enum DataTableAction {
  edit('edit'),
  delete('delete'),
  view('view'),
  add('add');

  final String type;
  const DataTableAction(this.type);
}
