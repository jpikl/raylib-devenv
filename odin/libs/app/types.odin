package app

App :: struct {
    init:   proc() -> bool,
    update: proc() -> bool,
    quit:   proc(),
}
