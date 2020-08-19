# Survey form modelling and structure

The survey form is the core of this project. When modelling its implementation,
we discovered two possibilities:

1) Implement each section of the form in a structure of `Questions` and `Answers`
2) Consider each section of the form as a domain entity in itself

We have opted to consider each section of the form as a domain entity in itself

## Why?

Implementing a survey form builder is outside the scope of the project. It would
be a lot of work to implement such a high level abstraction when we have no
requirement for doing so.

A structure where each section of the form maps to an entity - for instance,
`BuildingTenure` - makes it simpler to implement each section/form step as its
own resource.

## The design

As mentioned, we are mapping the paper form sections to individual domain
entities, this is the current mapping:

- Form section C7 -> `BuildingStatus`

- Form section C9 -> `BuildingTenure`

- Form section C10 -> `BuildingOwnership`

- Form section C11/C12 -> `BuildingHeight`

- Form sections C13 to C18 -> `BuildingExternalWalls`

- Form sections C19 to C24 -> `BuildingExternalWallAttachments`
