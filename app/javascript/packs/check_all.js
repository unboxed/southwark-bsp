function checkAll() {
    const boxes = document.querySelectorAll("#building_building_id_");
    const cb = document.getElementById("building_id");
    let i;

    for (i = 0; i < boxes.length; i++) {
        cb.checked ? boxes[i].checked = true : boxes[i].checked = false;
    }
}

document.addEventListener("DOMContentLoaded", (e) => {

    document.getElementById("building_id").addEventListener("change", e => {
        e.preventDefault();
        checkAll();
    })
})

