require 'matrix'

class Matrix
	def []=(i,j,x)
		@rows[i][j]=x
	end
end



#google nantoka
#pr(a) = (1-0.85) + 0.85(link value)


def mat

	m = Matrix[
	[0,0,0,1,0,1],
	[1,1,1,0,1,0],
	[0,0,1,0,0,0],
	[0,0,0,0,1,1],
	[0,1,1,0,0,0],
	[0,0,0,0,1,1]
	]

	pr = Array[1,1,1,1,1,1]
	tpr = Array[0,0,0,0,0,0]
	car = Array[0,0,0,0,0,0]

	i=0
	until i==m.row_size
		c = 0
		j=0
		t = m.row(i)
		until j==m.column_size
			if t[j]==1 then
				c = c+1
			end
			j = j+1
		end

		car[i] = c;

		j=0
		t = m.row(i)
		until j==m.column_size
			if t[j]==1 then 
				m[i,j] = t[j].to_r/c.to_r
			end
			j = j+1
		end

		i = i+1
	end

	m = m.t

	i=0
	until i==6
		p m.row(i)
		i = i+1
	end

	p "count list"
	i=0
	until i==6
		p car[i]
		i+=1
	end

	#detect pagerank
	#first step
	i=0
	until i==m.row_size
		s=0
		j=0
		t=m.row(i)
		until j==m.column_size
			if t[j]!=0 then
				s += pr[j]/car[i]
			end
			j+=1
		end
		pr[i] = 0.15+0.85*s

		i += 1
	end

	i=0
	until i==5
		tpr[i] = pr[i]
		p pr[i]
		i += 1
	end


	#next step
	while true

		if gets.chop=="n" then
			break
		else

			i=0
			until i==m.row_size
				s=0
				j=0
				t=m.row(i)
				until j==m.column_size
					if t[j]!=0 then
						s += tpr[j]/car[i]
					end
					j+=1
				end
				pr[i] = 0.15+0.85*s

				i += 1
			end

			
			i=0
			until i==5
				tpr[i] = pr[i]
				p pr[i]
				i += 1
			end
			print "\n"

		end

	end

end



mat()


