#!/bin/csh

set BsubMeika = ( ./Bsubtilis/Meika/*.csv )
set BsubSong = ( ./Bsubtilis/Song/*.csv )
set EcoliSong = ( ./Ecoli/Song/*.csv )
set EcoliUCI = ( ./Ecoli/UCI/*.csv )
set GenomeCod = ( ./Genome/CodingRegions/*.csv )
set GenomeWhole = ( ./Genome/WholeGenome/*.csv )
set all = ( $BsubMeika $BsubSong $EcoliSong $EcoliUCI $GenomeCod $GenomeWhole )

##### nucFrequency

##foreach myFile ( $BsubMeika )
##    python nucFrequency.py $myFile ./Bsubtilis/Meika/
##end

##foreach myFile ( $BsubSong )
##    python nucFrequency.py $myFile ./Bsubtilis/Song/
##end

##foreach myFile ( $EcoliSong )
##    python nucFrequency.py $myFile ./Ecoli/Song/
##end

##foreach myFile ( $EcoliUCI )
##    python nucFrequency.py $myFile ./Ecoli/UCI/
##end

##foreach myFile ( $GenomeCod )
##    python nucFrequency.py $myFile ./Genome/CodingRegions/
##end

##foreach myFile ( $GenomeWhole )
##    python nucFrequency.py $myFile ./Genome/WholeGenome/
##end


##### createPWM

##foreach myFile ( $BsubMeika )
##    python createPWM.py csv $myFile ./Bsubtilis/Meika/
##end

##foreach myFile ( $BsubSong )
##    python createPWM.py csv $myFile ./Bsubtilis/Song/
##end

##foreach myFile ( $EcoliSong )
##    python createPWM.py csv $myFile ./Ecoli/Song/
##end

##foreach myFile ( $EcoliUCI )
##    python createPWM.py csv $myFile ./Ecoli/UCI/
##end



##### createLogo

set BsubMeika = ( ./Bsubtilis/Meika/*.pfm )
set BsubSong = ( ./Bsubtilis/Song/*.pfm )
set EcoliSong = ( ./Ecoli/Song/*.pfm )
set EcoliUCI = ( ./Ecoli/UCI/*.pfm )

##foreach myFile ( $BsubMeika )
##    python createLogo.py 20 $myFile ./Bsubtilis/Meika/logo/
##end

##foreach myFile ( $BsubSong )
##    python createLogo.py 20 $myFile ./Bsubtilis/Song/logo/
##end

##foreach myFile ( $EcoliSong )
##    python createLogo.py 20 $myFile ./Ecoli/Song/logo/
##end

foreach myFile ( $EcoliUCI )
    python createLogo.py 20 $myFile ./Ecoli/UCI/logo/
end









