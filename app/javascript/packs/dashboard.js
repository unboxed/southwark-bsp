function setCheckbox(value, key) {
  if (value == "1") {
    checkbox = document.querySelector(`#${key}`);

    if (!checkbox) {
      console.warn(`no checkbox found for ${key}`);
    }

    checkbox.checked = true;
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const params = new URL(document.location).searchParams;

  const searchKeys = Array.from(params.keys());
  const hasSearch = searchKeys.some(key => key != "commit");

  if (hasSearch) {
    params.forEach(setCheckbox);
  }
});
