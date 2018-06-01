function toggleSelections() {
    checkboxes = document.getElementsByName('id');
    for (var i=0, n=checkboxes.length; i<n; i++) {
        checkboxes[i].checked = !checkboxes[i].checked;
    }
}
