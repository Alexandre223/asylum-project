**********************************
** Generate indicater variables **
**********************************

egen T=group(year quarter)
egen D=group(destination)
egen O=group(origin)
egen DO=group(destination origin)
egen OT=group(origin T)
