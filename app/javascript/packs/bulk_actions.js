function hasAnyChecked() {
  return !!document.querySelector(
    ".govuk-table tr input[type='checkbox']:checked"
  );
}

function checkAll(event) {
  const { target: { checked: shouldEnable } } = event;

  document.querySelectorAll("#building_building_id_").forEach(node => {
    node.checked = shouldEnable;
  });
}

function setBulkActionsEnabled(enabled) {
  document
    .querySelectorAll(".bulk-actions input")
    .forEach(node => (node.disabled = !enabled));
}

function toggleBulkActions() {
  setBulkActionsEnabled(hasAnyChecked());
}

function setupBulkActions() {
  document
    .querySelectorAll("#building_building_id_")
    .forEach(node => node.addEventListener("change", toggleBulkActions));
}

function setupMasterCheckbox() {
  document.getElementById("building_id").addEventListener("change", checkAll);

  document
    .getElementById("building_id")
    .addEventListener("change", toggleBulkActions);
}

document.addEventListener("DOMContentLoaded", e => {
  setupBulkActions();
  setupMasterCheckbox();

  toggleBulkActions();
});
