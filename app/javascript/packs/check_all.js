function checkAll() {
    const cb = document.getElementById("building_id");
    const boxes = document.querySelectorAll("#building_building_id_");
    let i;

    document.getElementById("building_id").addEventListener("change", e => {
        e.preventDefault();

        for (i = 0; i < boxes.length; i++) {
            cb.checked ? boxes[i].checked = true : boxes[i].checked = false;
        }
    })
}

document.addEventListener("turbolinks:load", (e) => {
    e.preventDefault();

    checkAll();
});

