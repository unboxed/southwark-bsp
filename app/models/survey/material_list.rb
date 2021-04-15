module Survey
  class MaterialList
    include Enumerable

    delegate :each, to: :@materials
    delegate :size, :empty?, to: :@materials

    def initialize(materials = [])
      @materials = materials
    end

    def min_coverage
      sum { |m| m.coverage - 10 }
    end

    def max_coverage
      sum { |m| m.coverage + 10 }
    end

    def find(id)
      detect(raise_not_found(id)) { |m| m.id == id }
    end

    def delete(id)
      @materials.delete(find(id))
    end

    def append(material)
      @materials.append(material)
    end

    def update(material)
      @materials.each do |item|
        next unless item.id == material.id

        item.assign_attributes(material.attributes)
      end
    end

    def as_json(*)
      @materials
    end

    private

    def raise_not_found(id)
      -> { raise Survey::MaterialNotFound, "Couldn't find material with the id: #{id}" }
    end
  end
end
