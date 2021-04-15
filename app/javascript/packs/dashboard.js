function openFiltersPanel() {
  document.querySelector(".filters").setAttribute("open", true);
}

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

  let searchKeys = [];
  params.keys(key => allKeys.push(key));

  if (!!searchKeys) {
    openFiltersPanel();

    params.forEach(setCheckbox);
  }
});
