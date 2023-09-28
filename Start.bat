cd eta-py
call .\env\Scripts\activate
(
echo ^{
echo.  "user_id": "doctor",
echo.  "user_name": "Dr. Tom Carroll",
echo.  "start_schema": "have-eta-dialog.v"
echo ^}
) > user_config/doctor.json
echo. 2> io/sophie-gpt/doctor/turn-output.txt
echo. 2> io/sophie-gpt/doctor/turn-affect.txt
python -m eta.core.eta --agent sophie_gpt_%1 --user doctor