function calculatePercentage() {
  const materials = document.querySelectorAll(".material");
  const material_percentage = document.getElementById("material_percentage");
  const length = materials.length;
  let acc = 0;
  let count = 0;

  if (materials) {
    for (let i = 0; i < length; i++) {
      count += +materials[i].value;
      acc = count;
      if (acc > 100) {
        material_percentage.innerHTML = acc + "%"
        percentage_error_message.innerHTML = "Can not be more than 100%"
      } else {
        material_percentage.innerHTML = acc + "%";
      }
    }
  }
}

document.addEventListener("keyup", e => {
  e.preventDefault();

  calculatePercentage();
})