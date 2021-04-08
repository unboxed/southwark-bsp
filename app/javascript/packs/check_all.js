function checkAll() {
    const cb = document.getElementById("building_id");
    const boxes = document.querySelectorAll("#building_building_id_");
    let i;

    if (cb.checked) {
        for (i = 0; i < boxes.length; i++) {
            boxes[i].checked = true;
        }
    }
}

document.addEventListener("change", e => {
    e.preventDefault();

    checkAll();
})

