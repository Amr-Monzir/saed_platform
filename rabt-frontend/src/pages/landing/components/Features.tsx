import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Card from "@mui/material/Card";
import MuiChip from "@mui/material/Chip";
import Container from "@mui/material/Container";
import Typography from "@mui/material/Typography";
import { styled } from "@mui/material/styles";

import PaletteIcon from "@mui/icons-material/Palette";
import StarIcon from "@mui/icons-material/Star";
import WatchLaterIcon from "@mui/icons-material/WatchLater";
import BoltIcon from "@mui/icons-material/Bolt";

const items = [
  {
    icon: <PaletteIcon />,
    title: "For Palestinian Causes",
    description:
      "Rabt is the only platform specifically catering to Palestinian causes, connecting you with opportunities to make a real difference.",
    imageLight: `url("${import.meta.env.BASE_URL}static/march.jpeg")`,
    imageDark: `url("${import.meta.env.BASE_URL}static/march.jpeg")`,
  },
  {
    icon: <StarIcon />,
    title: "Utilise Your Unique Skills",
    description:
      "We want to best utilise your skills for sustained, organised action. Find roles that match your expertise and passion.",
    imageLight: `url("${import.meta.env.TEMPLATE_IMAGE_URL || "https://mui.com"}/static/images/templates/templates-images/mobile-light.png")`,
    imageDark: `url("${import.meta.env.TEMPLATE_IMAGE_URL || "https://mui.com"}/static/images/templates/templates-images/mobile-dark.png")`,
  },
  {
    icon: <WatchLaterIcon />,
    title: "Volunteer At Your Own Pace",
    description:
      "Rabt allows you to volunteer at your own pace, offering flexibility to fit your schedule and commitments.",
    imageLight: `url("${import.meta.env.TEMPLATE_IMAGE_URL || "https://mui.com"}/static/images/templates/templates-images/devices-light.png")`,
    imageDark: `url("${import.meta.env.TEMPLATE_IMAGE_URL || "https://mui.com"}/static/images/templates/templates-images/devices-dark.png")`,
  },
  {
    icon: <BoltIcon />,
    title: "Create the Largest Impact",
    description:
      "Rabt gives you the ability to shine your skills to create the largest impact, contributing to meaningful projects.",
    imageLight: `url("${import.meta.env.TEMPLATE_IMAGE_URL || "https://mui.com"}/static/images/templates/templates-images/devices-light.png")`,
    imageDark: `url("${import.meta.env.TEMPLATE_IMAGE_URL || "https://mui.com"}/static/images/templates/templates-images/devices-dark.png")`,
  },
];

interface ChipProps {
  selected?: boolean;
}

const Chip = styled(MuiChip)<ChipProps>(({ theme }) => ({
  variants: [
    {
      props: ({ selected }) => !!selected,
      style: {
        background:
          "linear-gradient(to bottom right, hsl(210, 98%, 48%), hsl(210, 98%, 35%))",
        color: "hsl(0, 0%, 100%)",
        borderColor: (theme.vars || theme).palette.primary.light,
        "& .MuiChip-label": {
          color: "hsl(0, 0%, 100%)",
        },
        ...theme.applyStyles("dark", {
          borderColor: (theme.vars || theme).palette.primary.dark,
        }),
      },
    },
  ],
}));

interface MobileLayoutProps {
  selectedItemIndex: number;
  handleItemClick: (index: number) => void;
  selectedFeature: (typeof items)[0];
}

export function MobileLayout({
  selectedItemIndex,
  handleItemClick,
  selectedFeature,
}: MobileLayoutProps) {
  if (!items[selectedItemIndex]) {
    return null;
  }

  return (
    <Box
      sx={{
        display: { xs: "flex", sm: "none" },
        flexDirection: "column",
        gap: 2,
      }}
    >
      <Box sx={{ display: "flex", gap: 2, overflow: "auto" }}>
        {items.map(({ title }, index) => (
          <Chip
            size="medium"
            key={index}
            label={title}
            onClick={() => handleItemClick(index)}
            selected={selectedItemIndex === index}
          />
        ))}
      </Box>
      <Card variant="outlined">
        <Box
          sx={(theme) => ({
            mb: 2,
            backgroundSize: "cover",
            backgroundPosition: "center",
            minHeight: 280,
            backgroundRepeat: "no-repeat",
            backgroundImage: "var(--items-imageLight)",
            ...theme.applyStyles("dark", {
              backgroundImage: "var(--items-imageDark)",
            }),
          })}
          style={
            items[selectedItemIndex]
              ? ({
                  "--items-imageLight": items[selectedItemIndex].imageLight,
                  "--items-imageDark": items[selectedItemIndex].imageDark,
                } as any)
              : {}
          }
        />
        <Box sx={{ px: 2, pb: 2 }}>
          <Typography
            gutterBottom
            sx={{ color: "white", fontWeight: "medium" }}
          >
            {selectedFeature.title}
          </Typography>
          <Typography variant="body2" sx={{ color: "white", mb: 1.5 }}>
            {selectedFeature.description}
          </Typography>
        </Box>
      </Card>
    </Box>
  );
}

export default function Features() {
  const [selectedItemIndex, setSelectedItemIndex] = React.useState(0);

  const handleItemClick = (index: number) => {
    setSelectedItemIndex(index);
  };

  const selectedFeature = items[selectedItemIndex];

  return (
    <Box
      id="highlights"
      sx={{
        pt: { xs: 4, sm: 12 },
        pb: { xs: 8, sm: 16 },
        color: "white",
        bgcolor: "#007a3d",
      }}
    >
      <Container id="features" sx={{ py: { xs: 8, sm: 0 } }}>
        <Box sx={{ width: { sm: "100%", md: "100%" } }}>
          <Typography
            component="h2"
            variant="h4"
            gutterBottom
            sx={{
              color: "text.light",

              textAlign: "center",
              marginBottom: "2rem",
            }}
          >
            Why Rabt?
          </Typography>
        </Box>
        <Box
          sx={{
            display: "flex",
            flexDirection: { xs: "column", md: "row-reverse" },
            gap: 2,
          }}
        >
          <div>
            <Box
              sx={{
                display: { xs: "none", sm: "flex" },
                flexDirection: "column",
                gap: 2,
                height: "100%",
              }}
            >
              {items.map(({ icon, title, description }, index) => (
                <Box
                  key={index}
                  component={Button}
                  onClick={() => handleItemClick(index)}
                  sx={[
                    (theme) => ({
                      p: 2,
                      height: "100%",
                      width: "100%",
                      "&:hover": {
                        backgroundColor: (theme.vars || theme).palette.action
                          .hover,
                      },
                    }),
                    selectedItemIndex === index && {
                      backgroundColor: "action.selected",
                    },
                  ]}
                >
                  <Box
                    sx={[
                      {
                        width: "100%",
                        display: "flex",
                        flexDirection: "column",
                        alignItems: "left",
                        gap: 1,
                        textAlign: "left",
                        textTransform: "none",
                        color: "white",
                      },
                      selectedItemIndex === index && {
                        color: "white",
                      },
                    ]}
                  >
                    {icon}

                    <Typography variant="h6">{title}</Typography>
                    <Typography variant="body2">{description}</Typography>
                  </Box>
                </Box>
              ))}
            </Box>
            <MobileLayout
              selectedItemIndex={selectedItemIndex}
              handleItemClick={handleItemClick}
              selectedFeature={selectedFeature}
            />
          </div>
          <Box
            sx={{
              display: { xs: "none", sm: "flex" },
              width: { xs: "100%", md: "70%" },
              height: "var(--items-image-height)",
            }}
          >
            <Card
              variant="outlined"
              sx={{
                height: "100%",
                width: "100%",
                display: { xs: "none", sm: "flex" },
                pointerEvents: "none",
              }}
            >
              <Box
                sx={(theme) => ({
                  m: "auto",
                  width: 420,
                  height: 500,
                  backgroundRepeat: "no-repeat",
                  backgroundPosition: "center",
                  backgroundSize: "contain",
                  backgroundImage: "var(--items-imageLight)",
                  ...theme.applyStyles("dark", {
                    backgroundImage: "var(--items-imageDark)",
                  }),
                })}
                style={
                  items[selectedItemIndex]
                    ? ({
                        "--items-imageLight":
                          items[selectedItemIndex].imageLight,
                        "--items-imageDark": items[selectedItemIndex].imageDark,
                      } as any)
                    : {}
                }
              />
            </Card>
          </Box>
        </Box>
      </Container>
    </Box>
  );
}
