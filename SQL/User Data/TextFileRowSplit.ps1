$folder = "C:\xampp\htdocs\corkboardBackup\SQL\User Data"
$readerfilename = "insert_1000_users.sql"
$linespersplitfile = 4001

[IO.Directory]::SetCurrentDirectory($folder)
$reader = [System.IO.File]::OpenText($readerfilename)

try {
    $counter = 0
    $filecounter = 1
    $writerfilename = $readerfilename + "_" + $filecounter
    $writer = [System.IO.File]::CreateText($writerfilename)
    for(;;) {
        $line = $reader.ReadLine()
        if ($line -eq $null) { break }
        
        if($counter -eq $linespersplitfile)
        {
            $counter = 0
            $filecounter++
            $writer.Close()
            $writerfilename = $readerfilename + "_" + $filecounter
            $writer = [System.IO.File]::CreateText($writerfilename)
        }
        
        $writer.WriteLine($line)
        $counter++
    }
}
finally {
    $writer.Close()
    $reader.Close()
}
