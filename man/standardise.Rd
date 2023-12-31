% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/toolBox.R
\name{standardise}
\alias{standardise}
\title{Standardisation}
\usage{
standardise(mat)
}
\arguments{
\item{mat}{a matrix (or a PhosphoExperiment object) with rows correspond 
to phosphosites and columns correspond to samples.}
}
\value{
A standardised matrix
}
\description{
Standardisation by z-score transformation.
}
\examples{
data('phospho_L6_ratio_pe')
data('SPSs')

grps = gsub('_.+', '', colnames(phospho.L6.ratio.pe))

# Construct a design matrix by condition
design = model.matrix(~ grps - 1)

# phosphoproteomics data normalisation using RUV
L6.sites = paste(sapply(GeneSymbol(phospho.L6.ratio.pe), function(x)paste(x)),
                 ";",
                 sapply(Residue(phospho.L6.ratio.pe), function(x)paste(x)),
                 sapply(Site(phospho.L6.ratio.pe), function(x)paste(x)),
                 ";", sep = "")
ctl = which(L6.sites \%in\% SPSs)
phospho.L6.ratio.pe = RUVphospho(phospho.L6.ratio.pe,
                                 M = design, k = 3,ctl = ctl)

phosphoL6 = SummarizedExperiment::assay(phospho.L6.ratio.pe, "normalised")

# filter for up-regulated phosphosites
phosphoL6.mean <- meanAbundance(phosphoL6, grps = grps)
aov <- matANOVA(mat=phosphoL6, grps = grps)
phosphoL6.reg <- phosphoL6[(aov < 0.05) &
                        (rowSums(phosphoL6.mean > 0.5) > 0),,drop = FALSE]
L6.phos.std <- standardise(phosphoL6.reg)

}
