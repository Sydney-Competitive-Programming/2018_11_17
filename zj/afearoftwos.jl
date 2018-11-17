x=1:Int(1e6)
x[[!occursin(r"2","$x") for x in x]]