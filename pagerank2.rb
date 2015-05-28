
require 'matrix'


class Matrix
	def []=(i,j,x)
		@rows[i][j]=x
	end
end

def mat
	car			= Array[]
	pr 			= Array[]
	tpr			= Array[]

	num2id = Hash.new
	id2title = Hash.new

	continue = 1
	threshold = 0.0001

	running_counter=0

	#1 minute
	p "making num2id hash table"
	fp = open("parsepage4.txt","r:UTF-8")do |fp|
		c=0
		while line = fp.gets
			t = line.encode("UTF-16BE", :invalid=>:replace,:undef=>:replace,:replace=>'').encode("UTF-8")
			tt = t.split(",")

			num2id[tt[0]] = c
			id2title[tt[1].gsub("\n","")] = tt[0]

			c+=1

			if c%10000==0 then
				puts c
			end

			#initializing google matrix
			pr << 1
			tpr << 1
		end
	end

	p "make void matrix"
	m = Matrix.scalar(num2id.size,0)

	p "detecting page link"
	fpl = open("parsepagelinks3.txt","r:utf-8")do |fpl|
		while line = fpl.gets
			t = line.encode("UTF-16BE", :invalid=>:replace,:undef=>:replace,:replace=>'').encode("UTF-8")

			link = t.split(",")
			
			#detect page id
			r = num2id[link[0]].to_i
			
			#detect retsu
			h = num2id[id2title[link[1].gsub("\n","")].to_s].to_i

			m[r,h]=1
		end
	end


	p "counting linked page number"
	for i in 0..m.column_size-1 do
		ary = m.row(i)
		t = ary.inject(:+)
		car << t
	
		for j in 0..ary.size-1 do
			m[i,j] = ary[j].to_r/t.to_r
		end
	end


	p "writing prepared matrix"
	f = open("matrix.txt","w")do |f|
		for i in 0..m.column_size-1 do
			t = m.row(i).to_s.gsub("Vector[","")
			t.gsub!("]","")
			t.gsub!(" ","")
			
			f.write(t)
			f.write("\n")
		end	
	end

	switch=0

	p "detecting pagerank(1)"
	for i in 0..m.column_size-1 do
		ary = m.row(i)
		s=0
		for j in 0..ary.size-1 do
			if ary[j]!=0 then
				s += pr[j]/car[i]
			end
		end
		pr[i]=0.15+0.85*s
	end

	p "reversing"
	m = m.t

	p "detecting pagerank(2)"
	while true
		running_counter+=1
		p running_counter

		continue = 0

		if switch == 0 then
			switch = 1
			for i in 0..m.column_size-1 do
				ary = m.row(i)
				s=0
				for j in 0..ary.size-1 do
					if ary[j]!=0 then
						s += pr[j]/car[i]
					end
				end
				tpr[i]=0.15+0.85*s

				if continue == 0 then
					if (tpr[i]-pr[i]).abs > threshold then
						continue = 1
					end
				end

			end

		elsif switch == 1 then
			switch = 0
			for i in 0..m.column_size-1 do
				ary = m.row(i)
				s=0
				for j in 0..ary.size-1 do
					if ary[j]!=0 then
						s += tpr[j]/car[i]
					end
				end
				pr[i]=0.15+0.85*s

				if continue == 0 then
					if (tpr[i]-pr[i]).abs > threshold then
						continue = 1
					end
				end
			end

		end

		if continue == 0 then
			break
		end


		f = open("result.txt","w")do |f|
			for i in 0..pr.size-1 do
				f.write(pr[i])
				f.write("\n")
			end	
		end

	end
	p "finished detect pagerank"
	
end


mat