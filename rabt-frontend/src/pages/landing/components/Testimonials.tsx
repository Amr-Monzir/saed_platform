import * as React from "react";
import Card from "@mui/material/Card";
import CardHeader from "@mui/material/CardHeader";
import CardContent from "@mui/material/CardContent";
import Avatar from "@mui/material/Avatar";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import Container from "@mui/material/Container";
import Grid from "@mui/material/Grid";
import { useColorScheme } from "@mui/material/styles";

const userTestimonials = [
  {
    avatar: <Avatar alt="Sarah, London" src="/static/images/avatar/1.jpg" />,
    name: "Sarah, London",
    occupation: "Software Engineer",
    testimonial:
      "Finally, a way to use my professional skills for good. I contributed to a project that streamlined their operations, and seeing the immediate positive impact was incredibly satisfying. It's the most meaningful work I've done.",
  },
  {
    avatar: <Avatar alt="Ahmed" src="/static/images/avatar/2.jpg" />,
    name: "Ahmed, Düsseldorf",
    occupation: "Graphic Designer",
    testimonial:
      "I love that I can volunteer my design skills whenever I have free time. I'm not tied to a rigid schedule, which means I can help out when I'm most creative and available. It's the perfect way to give back.",
  },
  {
    avatar: (
      <Avatar alt="Fatima, Sheffield" src="/static/images/avatar/3.jpg" />
    ),
    name: "Fatima, Sheffield",
    occupation: "Marketing Manager",
    testimonial:
      "Being able to help a cause I believe in from my own home, on my own time, is fantastic. I helped them craft a marketing campaign, and watching the community's response grow was amazing. It's volunteering that truly fits my life.",
  },
];

export default function Testimonials() {
  const { mode, systemMode } = useColorScheme();

  return (
    <Container
      id="testimonials"
      sx={{
        pt: { xs: 4, sm: 12 },
        pb: { xs: 8, sm: 16 },
        position: "relative",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        gap: { xs: 3, sm: 6 },
      }}
    >
      <Box
        sx={{
          width: { sm: "100%", md: "60%" },
          textAlign: { sm: "left", md: "center" },
        }}
      >
        <Typography
          component="h2"
          variant="h4"
          gutterBottom
          sx={{ color: "text.primary" }}
        >
          Testimonials
        </Typography>
        <Typography variant="body1" sx={{ color: "text.secondary" }}>
          See what our volunteers love about RABT. Discover how you can
          contribute. Empower us!
        </Typography>
      </Box>
      <Grid container spacing={2}>
        {userTestimonials.map((testimonial, index) => (
          <Grid
            size={{ xs: 12, sm: 6, md: 4 }}
            key={index}
            sx={{ display: "flex" }}
          >
            <Card
              variant="outlined"
              sx={{
                display: "flex",
                flexDirection: "column",
                justifyContent: "space-between",
                flexGrow: 1,
              }}
            >
              <CardContent>
                <Typography
                  variant="body1"
                  gutterBottom
                  sx={{ color: "text.secondary" }}
                >
                  {testimonial.testimonial}
                </Typography>
              </CardContent>
              <Box
                sx={{
                  display: "flex",
                  flexDirection: "row",
                  justifyContent: "space-between",
                }}
              >
                <CardHeader
                  avatar={testimonial.avatar}
                  title={testimonial.name}
                  subheader={testimonial.occupation}
                />
              </Box>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Container>
  );
}
