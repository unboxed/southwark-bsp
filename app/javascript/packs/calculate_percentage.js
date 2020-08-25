function calculatePercentage() {
  const materials = document.querySelectorAll(".material");
  const material_percentage = document.getElementById("material_percentage");
  const length = materials.length;
  let acc = 0;
  let count = 0;
 
  if (materials) {
    for(let i = 0; i < length; i++){
        count += +materials[i].value;
        acc = count;
        material_percentage.innerHTML = acc + "%";
    }
  }
}

document.addEventListener("keyup", e => {
  e.preventDefault();

  calculatePercentage();
})
