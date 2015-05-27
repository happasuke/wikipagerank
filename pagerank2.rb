#
# page 51 ~ 2758850
#
# page links 40 ~ 
#

require 'matrix'


class Matrix
	def []=(i,j,x)
		@rows[i][j]=x
	end
end

def mat
	num2id		= Array[]
	num2name 	= Array[]
	car			= Array[]
	pr 			= Array[]
	tpr			= Array[]
	h = Hash.new


	continue = 1
	threshold = 0.0001

	running_counter=0

	#1 minute
	p "making num2id"
	fp = open("parsepage4.txt","r:UTF-8")do |fp|
		c=0
		while line = fp.gets
			t = line.encode("UTF-16BE", :invalid=>:replace,:undef=>:replace,:replace=>'').encode("UTF-8")
			tt = t.split(",")

			num2id << tt[0]
			h[tt[1].gsub("\n","")] = tt[0]

			c+=1

			if c%10000==0 then
				puts c
			end

			#initializing google matrix
			pr << 1
			tpr << 1
		end
	end

	p "definning matrix"
	m = Matrix.scalar(h.size-1,0)

	p "making matrix"
	fpl = open("parsepagelink2.txt","r:utf-8")do |fpl|
		while line = fpl.gets
			t = line.encode("UTF-16BE", :invalid=>:replace,:undef=>:replace,:replace=>'').encode("UTF-8")

			tt = t.split(",")

			#detect gyou
			n = tt[0]
			l = 0
			h = num2id.size-1
			mid = 0

			pos = -1
			while l<=h do
				mid = (l+h)/2
				if num2id[m]==n then
					pos = mid
					break
				elsif aa[m]>n then
					h = mid-1
				elsif aa[m]<n then
					l = mid+1
				end
			end

			
			#detect retsu
			s = tt[1]
			m[pos,num2id[h[s]]]=1
			

		end
	end

	p "making prepare matrix"
	for i in 0..m.column_size-1 do
		ary = m.row(i)
		t = ary.inject(:+)
		car << t
	
		for j in 0..ary.size-1 do
			m[i,j] = ary[j].to_r/t.to_r
		end
	end

	p car

	switch=0

	p "detecting pagerank"
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

#doudesyou
	m = m.t

	i=0
	until i==6
		p pr[i]
		i += 1
	end

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

	end
	p "finished detect pagerank"

	p pr
end


mat