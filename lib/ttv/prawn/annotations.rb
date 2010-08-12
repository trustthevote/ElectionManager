require "prawn/document/annotations"

module TTV
  module Prawn
    module Annotation

      # Couldn't use the annotate method because it doesn't create one
      # level of indirection that's needed for annotations. EX:
      # in page object
      # /Annots 9 0 R
      # indirection to array of widget annotations is the 9 0 R object
      # 9 0 obj
      # [10 0 R]
      # endobj
      # The Widget annotation, points the XObject form obj containing
      # references to object, 8 0 R and 7 0 %, that contain graphics
      # primitives to draw states
      # 10 0 R
      # ...
      # /AP << /N << /Yes 8 0 R /Off 7 0 R >>
      # ...
      # returns - reference to Widget annotaton/Field definition, 10 0 R
      def annotate_redirect(options)
        # create an array that will have a ref for each annotation of this page
        page.dictionary.data[:Annots] ||= ref!([])
        # TODO: do more checks for correct options here
        options = sanitize_annotation_hash(options)
        # create a reference used for the Widget annotation and the field
        annot_ref = ref!(options)
        # append this ref to the array of annotations
        page.dictionary.data[:Annots].data << annot_ref
        annot_ref 
      end
    end
  end
end