function Get-FileEncoding {
    <#    
      .SYNOPSIS
        Get the file encoding of a given file.
      .DESCRIPTION
        Unknown source.
      .PARAMETER Path
        The path to the file to get the encoding for.
      .EXAMPLE
        dir -file | Get-FileEncoding
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory,
            Position = 0)] 
        [Alias("FullName")]
        $Path
    )
    PROCESS {
        ## First, check if the file is binary. That is, if the first
        ## 5 lines contain any non-printable characters.
        $nonPrintable = [char[]] (0..8 + 10..31 + 127 + 129 + 141 + 143 + 144 + 157)
        $lines = Get-Content $Path -ErrorAction Ignore -TotalCount 5
        $result = @($lines | Where-Object { $_.IndexOfAny($nonPrintable) -ge 0 })
        if ($result.Count -gt 0) {
            "Binary"
            return
        }

        ## Next, check if it matches a well-known encoding.

        ## The hashtable used to store our mapping of encoding bytes to their
        ## name. For example, "255-254 = Unicode"
        $encodings = @{ }

        ## Find all of the encodings understood by the .NET Framework. For each,
        ## determine the bytes at the start of the file (the preamble) that the .NET
        ## Framework uses to identify that encoding.
        foreach ($encoding in [System.Text.Encoding]::GetEncodings()) {
            $preamble = $encoding.GetEncoding().GetPreamble()
            if ($preamble) {
                $encodingBytes = $preamble -join '-'
                $encodings[$encodingBytes] = $encoding.GetEncoding()
            }
        }

        ## Find out the lengths of all of the preambles.
        $encodingLengths = $encodings.Keys | Where-Object { $_ } |
        Foreach-Object { ($_ -split "-").Count }

    ## Assume the encoding is UTF7 by default
    $result = [System.Text.Encoding]::UTF7

    ## Go through each of the possible preamble lengths, read that many
    ## bytes from the file, and then see if it matches one of the encodings
    ## we know about.
    foreach ($encodingLength in $encodingLengths | Sort -Descending) {
        $bytes = Get-Content -Encoding byte -readcount $encodingLength $path | Select -First 1
        $encoding = $encodings[$bytes -join '-']

        ## If we found an encoding that had the same preamble bytes,
        ## save that output and break.
        if ($encoding) {
            $result = $encoding
            break
        }
    }

    [PSCustomObject][ordered]@{File = $Path; Encoding = $result }
}
}
