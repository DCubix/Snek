return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.0.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 8,
  height = 8,
  tilewidth = 8,
  tileheight = 8,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "def",
      firstgid = 1,
      filename = "tmap",
      tilewidth = 8,
      tileheight = 8,
      spacing = 0,
      margin = 0,
      image = "tiles.png",
      imagewidth = 32,
      imageheight = 48,
      transparentcolor = "#ff00ff",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 8,
        height = 8
      },
      properties = {},
      terrains = {},
      tilecount = 24,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        4, 4, 2, 1, 2, 2, 1, 2,
        4, 1, 4, 5, 1, 1, 6, 2,
        2, 1, 1, 4, 2, 4, 1, 4,
        1, 4, 1, 4, 4, 2, 4, 4,
        2, 1, 2, 1, 4, 5, 4, 4,
        2, 2, 4, 2, 6, 2, 1, 4,
        4, 5, 4, 4, 4, 4, 2, 4,
        1, 2, 4, 1, 4, 4, 4, 1
      }
    }
  }
}
