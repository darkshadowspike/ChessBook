module ApplicationHelper
	def title_changer(title ="")
		base_title ="Chessbook"

		if title.empty?
			return base_title
		else
			return base_title + " - " + title
		end
	end
end
