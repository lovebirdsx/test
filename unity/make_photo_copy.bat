@echo off
if not exist photo_copy (
    md photo_copy
    mklink /J %cd%\photo_copy\Assets %cd%\Photo\Assets
    mklink /J %cd%\photo_copy\ProjectSettings %cd%\Photo\ProjectSettings
    mklink /J %cd%\photo_copy\Library %cd%\Photo\Library
)
