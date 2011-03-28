require 'paperclip_processors/watermark_p'
class Topic < ActiveRecord::Base

  belongs_to :category
  
  has_attached_file :cover, :processors => [:watermark],
    :styles => {  
      :original => {  
        :geometry => '440x280#',  
        :watermark_path => "#{Rails.root}/public/images/rails.png",
        :position => 'SouthEast'
      }
    },
    :url => "/uploads/:class/:attachment/:id_:style.jpg",
    :path => ":rails_root/public/uploads/:class/:attachment/:id_:style.jpg"
    
end
