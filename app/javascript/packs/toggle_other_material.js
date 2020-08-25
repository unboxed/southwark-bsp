function toggleOther() {
  const materialOther = document.querySelector("#building_wall_materials_other");
  const materialDetails = document.querySelector("#other_material_details");

  if (materialOther) {
    materialOther.addEventListener("click", (e) => {
      materialOther.checked ? materialDetails.classList.remove("govuk-visually-hidden") : materialDetails.classList.add("govuk-visually-hidden");
    });
  }
}

document.addEventListener("turbolinks:load", (e) => {
  e.preventDefault();

  toggleOther();
});
