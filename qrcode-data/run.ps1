param(
    [string]$ExcelFile = "sample_data.xlsx"
)

if (-not (Test-Path $ExcelFile)) {
    Write-Host "[ERR] Khong tim thay file: $ExcelFile" -ForegroundColor Red
    Write-Host "Cach dung: .\run.ps1 -ExcelFile duong_dan_file.xlsx"
    exit 1
}

$env:PYTHONIOENCODING = 'utf-8'
python generate_qr.py $ExcelFile
