p = "D:/git/syd-comp-prog/2018_11_17/snake_windows.txt"

return_board(p,n) = begin
    open(p) do f
        linecounter = 0
        for l in eachline(f)
            if linecounter == n
                return(parse.(Int, split(l)))
            end
            linecounter += 1
        end
    end
end
moves(n, m) = n + m <= 100 ? n + m : 100 - (n+m-100)

function update_snake_on_game(n)
    x=return_board(p, n);
    x1 = x[1:2:end];
    x2 = x[2:2:end];
    update_snake(x1)
    update_snake(x2)
    snakes
end

function update_snake(x1)
    snakepos = findall(diff(x1) .< 0)
    for sp in snakepos
        deduce1 = x1[[sp,sp+1]]

        if !((deduce1[1] == 98 && deduce1[2] >=96) || (deduce1[1] == 99 && deduce1[2] >=95))
            #println(deduce1)
            new_res = setdiff(moves.(deduce1[1],1:6), non_ls)
            new_res = setdiff(new_res, l_ls)
            new_res = setdiff(new_res, s_ls)
            #println(new_res)
            #println("")
            if haskey(snakes, deduce1[2])
                old_res = snakes[deduce1[2]]
                fnl_res = intersect(old_res, new_res)
            else
                fnl_res = snakes[deduce1[2]] = new_res
            end
            if length(fnl_res) == 1
                push!(s_ls, fnl_res[1])
            end
            if length(fnl_res) > 0
                snakes[deduce1[2]] = fnl_res
            end
        end
    end
    snakes
end

ladders =Dict{Int, Vector{Int}}();
snakes = Dict{Int, Vector{Int}}();
l_ls = Int[]
s_ls = Int[]
non_ls = vcat(1, unique(vcat(return_board.([p],1:14)...)) |> sort);

update_snake_on_game.(1:14)
snakes

function update_ladder(x1)
    ladderpos = findall(diff(x1) .> 6)
    for sp in ladderpos
        deduce1 = x1[[sp,sp+1]]
        #println(deduce1)
        new_res = setdiff(moves.(deduce1[1],1:6), non_ls)
        new_res = setdiff(new_res, l_ls)
        new_res = setdiff(new_res, s_ls)
        #println(new_res)
        #println("")
        if haskey(ladders, deduce1[2])
            old_res = ladders[deduce1[2]]
            fnl_res = intersect(old_res, new_res)
        else
            fnl_res = ladders[deduce1[2]] = new_res
        end
        if length(fnl_res) == 1
            push!(l_ls, fnl_res[1])
        end
        if length(fnl_res) > 0
            ladders[deduce1[2]] = fnl_res
        end
    end
    ladders
end

function update_ladder_on_game(n)
    x=return_board(p, n);
    x1 = x[1:2:end];
    x2 = x[2:2:end];
    update_ladder(x1)
    update_ladder(x2)
    ladders
end

update_ladder_on_game.(1:14)

snakes

ladders

# eliminate
for k in keys(snakes)
    if length(snakes[k]) > 1
        vl = [v[1] for v in values(ladders)]
        snakes[k] = setdiff(snakes[k], vl)
    end
end

println("")
println("snakes")
for (to, from) in snakes
    println("$(from[1]) to $to")
end

println("")
println("ladders")
for (to, from) in ladders
    println("$(from[1]) to $to")
end
