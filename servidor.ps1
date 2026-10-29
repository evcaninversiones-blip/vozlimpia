# Sirve VozLimpia en http://localhost:8765 (el micrófono solo funciona en localhost o https)
# y la abre como ventana de aplicación en Edge o Chrome.
$root = $PSScriptRoot
$port = 8765
$url  = "http://localhost:$port/"

$types = @{ '.html'='text/html; charset=utf-8'; '.js'='text/javascript; charset=utf-8'; '.json'='application/manifest+json';
            '.svg'='image/svg+xml'; '.css'='text/css; charset=utf-8'; '.png'='image/png' }

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
try { $listener.Start() } catch {
    # Ya hay una instancia corriendo: solo abrimos la ventana
    $listener = $null
}

$edge   = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
$chrome = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
if (Test-Path $edge)       { Start-Process $edge   "--app=$url" }
elseif (Test-Path $chrome) { Start-Process $chrome "--app=$url" }
else                       { Start-Process $url }

if (-not $listener) { exit }
Write-Host "VozLimpia funcionando en $url  (cierra esta ventana para apagarla)"

while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $path = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
    if ($path -eq '') { $path = 'index.html' }
    $file = [IO.Path]::GetFullPath((Join-Path $root $path))
    $res = $ctx.Response
    if ($file.StartsWith($root) -and (Test-Path $file -PathType Leaf)) {
        $bytes = [IO.File]::ReadAllBytes($file)
        $ext = [IO.Path]::GetExtension($file).ToLower()
        $res.ContentType = if ($types[$ext]) { $types[$ext] } else { 'application/octet-stream' }
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
    } else { $res.StatusCode = 404 }
    $res.Close()
}
